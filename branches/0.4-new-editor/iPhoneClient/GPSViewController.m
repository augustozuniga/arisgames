//
//  GPSViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "GPSViewController.h"
#import "AppModel.h"
#import "Location.h"
#import "Player.h"
#import "ARISAppDelegate.h"
#import "AnnotationView.h"


//static int DEFAULT_ZOOM = 16;
//static float INITIAL_SPAN = 0.001;

@implementation GPSViewController

@synthesize mapView;
@synthesize moduleName;
@synthesize autoCenter;

//Override init for passing title and icon to tab bar
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        self.title = @"GPS";
        self.tabBarItem.image = [UIImage imageNamed:@"GPS.png"];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
												   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
												   target:self 
												   action:@selector(refresh:)] autorelease];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
												  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
												  target:self 
												  action:@selector(changeMapType:)] autorelease];
	}
	
	autoCenter = YES;
    return self;
}
		
- (IBAction)changeMapType: (id) sender {
	switch (mapView.mapType) {
		case MKMapTypeStandard:
			mapView.mapType=MKMapTypeSatellite;
			break;
		case MKMapTypeSatellite:
			mapView.mapType=MKMapTypeHybrid;
			break;
		case MKMapTypeHybrid:
			mapView.mapType=MKMapTypeStandard;
			break;
	}
}

- (IBAction)refresh: (id) sender{

	NSLog(@"GPS: Refresh Button Touched");
	
	//Center the Map
	[mapView setCenterCoordinate:appModel.playerLocation.coordinate animated:YES];
	
	//Force a location update
	ARISAppDelegate *appDelegate = (ARISAppDelegate *) [[UIApplication sharedApplication] delegate];
	[appDelegate.myCLController.locationManager stopUpdatingLocation];
	[appDelegate.myCLController.locationManager startUpdatingLocation];

	//Rerfresh all contents
	[self refreshMap];
	
	//Zoom and Center
	[self zoomAndCenterMap];

}
		
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	moduleName = @"RESTMap";
	
	NSLog(@"Begin Loading GPS View");
	
	//register for notifications
	NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
	[dispatcher addObserver:self selector:@selector(refreshMap) name:@"PlayerMoved" object:nil];
	[dispatcher addObserver:self selector:@selector(refreshMarkers) name:@"ReceivedLocationList" object:nil];
	
	NSLog(@"GPS ViewController is GPS observer");


	//Setup the Map
	CGFloat tableViewHeight = 416; // todo: get this from const
	CGRect mainViewBounds = self.view.bounds;
	CGRect tableFrame;
	tableFrame = CGRectMake(CGRectGetMinX(mainViewBounds),
							CGRectGetMinY(mainViewBounds),
							CGRectGetWidth(mainViewBounds),
							tableViewHeight);
	NSLog(@"Mapview about to be inited.");
	mapView = [[MKMapView alloc] initWithFrame:tableFrame];
	MKCoordinateRegion region = mapView.region;
	region.span.latitudeDelta=0.001;
	region.span.longitudeDelta=0.001;
	[mapView setRegion:region animated:NO];
	[mapView regionThatFits:region];
	[mapView setDelegate:self]; //View will request annotation views from us
	
	//mapView = [[RMMapView alloc] initWithFrame:tableFrame];
	
	NSLog(@"Mapview inited.");
    
	[self.view addSubview:mapView];

//	CGRect buttonFrame = self.view.bounds;
//	buttonFrame.size.width = 100;
//	buttonFrame.size.height = 60;
//	buttonFrame.origin.x -=70.0;
//	buttonFrame.origin.y -=70.0;
//	UIButton *mapTypeButton = [[UIButton alloc] initWithFrame:buttonFrame];
//	[
//	[self.view addSubview:mapTypeButton];
	
	//markerManager = [mapView markerManager];
	
	//Set up the Player Marker and Center the Map on them
	//Since we arn't ABSOLUTLY sure we have a valid playerLocation in the Model, make a fake one and let CLCController update later
	
	
	CLLocationCoordinate2D playerPosition;
	playerMarker = [[PlayerAnnotation alloc] initWithCoordinate:playerPosition];
	playerMarker.title = @"You";
	[mapView addAnnotation:playerMarker];

	
	
//	[markerManager addMarker:playerMarker AtLatLong:playerPosition];
	
	NSLog(@"GPS View Loaded");
}





-(void) setModel:(AppModel *)model {
	if(appModel != model) {
		[appModel release];
		appModel = model;
		[appModel retain];
	}
	NSLog(@"model set for GPS");
	
	[self refreshMap];
}




// Updates the map to current data for player and locations from the server
- (void) refreshMap {
	NSLog(@"GPS refreshMap requested");	
	//Move the player marker
	[self refreshPlayerMarker];
		
	//Ask for the Locations to be loaded into the model, which will trigger a notification to refreshMarkers here
	//[NSThread detachNewThreadSelector: @selector(fetchLocationList) toTarget:appModel withObject: nil];	
	[appModel fetchLocationList];

}

-(void) zoomAndCenterMap {
	
	//Center the map on the player
	MKCoordinateRegion region = mapView.region;
	region.center = appModel.playerLocation.coordinate;
	[mapView setRegion:region animated:YES];
	
	//Set to default zoom
	//mapView.contents.zoom = DEFAULT_ZOOM;
}

- (void)refreshPlayerMarker {
	//Move the player marker
	playerMarker.coordinate = appModel.playerLocation.coordinate;
	[self zoomAndCenterMap];
	
	//[markerManager moveMarker:playerMarker AtLatLon: appModel.lastLocation.coordinate];
	
//	if (appModel.lastLocation.horizontalAccuracy > 0 && appModel.lastLocation.horizontalAccuracy < 100)
//		[playerMarker replaceImage:[RMMarker loadPNGFromBundle:@"marker-player"] anchorPoint:CGPointMake(.5, .6)];
//	else [playerMarker replaceImage:[RMMarker loadPNGFromBundle:@"marker-player-lqgps"] anchorPoint:CGPointMake(.5, .6)];

//	//Center the first time
//	if (autoCenter == YES) [self zoomAndCenterMap];
//	autoCenter = NO;
}

- (void)refreshMarkers {
	NSLog(@"Refreshing Map Markers");
	
	//Blow away the old markers
	[mapView removeAnnotations:[mapView annotations]];
	
	//Add the player marker back in
	[mapView addAnnotation:playerMarker];
	
	//Add the freshly loaded locations from the notification
	for ( Location* location in appModel.locationList ) {
		NSLog(@"Location name:%@ id:%d", location.name, location.locationId);
		if (location.hidden == YES) continue;
		CLLocationCoordinate2D locationLatLong = location.location.coordinate;
		
		ItemAnnotation *anItem = [[ItemAnnotation alloc]initWithCoordinate:locationLatLong];
		anItem.title = location.name;
		if (location.qty > 0) anItem.subtitle = [NSString stringWithFormat:@"Quantity: %d", location.qty];
		[mapView addAnnotation:anItem];
		[mapView selectAnnotation:anItem animated:YES];

		[anItem release];
	}
	
	//Add the freshly loaded players from the notification
	for ( Player *player in appModel.playerList ) {
		if (player.hidden == YES) continue;
		CLLocationCoordinate2D locationLatLong = player.location.coordinate;
		
		
		//RMMarker *marker = [[RMMarker alloc]initWithCGImage:[RMMarker loadPNGFromBundle:@"marker-other-player"]];
//		[marker setTextLabel:player.name];
//		[markerManager addMarker:marker AtLatLong:locationLatLong];
//		[marker release];
		PlayerAnnotation *aPlayer = [[PlayerAnnotation alloc]initWithCoordinate:locationLatLong];
		aPlayer.title = player.name;
		[mapView addAnnotation:aPlayer];
		[aPlayer release];
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[appModel release];
	[moduleName release];
    [super dealloc];
}

#pragma mark Views for annotations

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	if ([annotation isMemberOfClass:[PlayerAnnotation class]]) {
		if ([annotation isEqual:playerMarker]) {
			AnnotationView *playerAnnotationView = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PlayerAnnotation"];
			playerAnnotationView.image = [UIImage imageNamed:@"marker-player.png"];
			return playerAnnotationView;
		} else {
			AnnotationView *playerAnnotationView = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"OtherPlayerAnnotation"];
			playerAnnotationView.image = [UIImage imageNamed:@"marker-other-player.png"];
			return playerAnnotationView;
		}
	} else {
		AnnotationView *annotationView=[[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
		annotationView.image = [UIImage imageNamed:@"pickaxe.png"];		
		return annotationView;
	}
}


@end

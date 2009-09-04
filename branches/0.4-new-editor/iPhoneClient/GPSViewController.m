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
@synthesize autoCenter;

//Override init for passing title and icon to tab bar
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        self.title = @"GPS";
        self.tabBarItem.image = [UIImage imageNamed:@"GPS.png"];
		appModel = [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
		
		autoCenter = YES;

		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
												   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
												   target:self 
												   action:@selector(refreshButtonAction:)] autorelease];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
												  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
												  target:self 
												  action:@selector(changeMapType:)] autorelease];
		
		//register for notifications
		NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
		[dispatcher addObserver:self selector:@selector(refresh) name:@"PlayerMoved" object:nil];
		[dispatcher addObserver:self selector:@selector(refreshViewFromModel) name:@"ReceivedLocationList" object:nil];
		
		
	}
	
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

- (IBAction)refreshButtonAction: (id) sender{

	NSLog(@"GPSViewController: Refresh Button Touched");
	
	//Center the Map
	[mapView setCenterCoordinate:appModel.playerLocation.coordinate animated:YES];
	
	//Force a location update
	ARISAppDelegate *appDelegate = (ARISAppDelegate *) [[UIApplication sharedApplication] delegate];
	[appDelegate.myCLController.locationManager stopUpdatingLocation];
	[appDelegate.myCLController.locationManager startUpdatingLocation];

	//Rerfresh all contents
	[self refresh];
	
	//Zoom and Center
	[self zoomAndCenterMap];

}
		
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"Begin Loading GPS View");

	//Setup the Map
	CGFloat tableViewHeight = 416; // todo: get this from const
	CGRect mainViewBounds = self.view.bounds;
	CGRect tableFrame;
	tableFrame = CGRectMake(CGRectGetMinX(mainViewBounds),
							CGRectGetMinY(mainViewBounds),
							CGRectGetWidth(mainViewBounds),
							tableViewHeight);
	NSLog(@"GPSViewController: Mapview about to be inited.");
	mapView = [[MKMapView alloc] initWithFrame:tableFrame];
	MKCoordinateRegion region = mapView.region;
	region.span.latitudeDelta=0.001;
	region.span.longitudeDelta=0.001;
	[mapView setRegion:region animated:NO];
	[mapView regionThatFits:region];
	[mapView setDelegate:self]; //View will request annotation views from us
	[self.view addSubview:mapView];
	NSLog(@"GPSViewController: Mapview inited and added to view");
	
	CLLocationCoordinate2D playerPosition;
	playerMarker = [[PlayerAnnotation alloc] initWithCoordinate:playerPosition];
	playerMarker.title = @"You";
	[mapView addAnnotation:playerMarker];

	[self refresh];		

	NSLog(@"GPSViewController: View Loaded");
}

// Updates the map to current data for player and locations from the server
- (void) refresh {
	NSLog(@"GPSViewController: refresh requested");	
	
	//Move the player marker
	[self refreshPlayerMarker];

	//Update the locations
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
}

- (void)refreshViewFromModel {
	NSLog(@"GPSViewController: Refreshing view from model");
	
	//Blow away the old markers
	[mapView removeAnnotations:[mapView annotations]];
	
	//Add the player marker back in
	[mapView addAnnotation:playerMarker];
	
	//Add the freshly loaded locations from the notification
	for ( Location* location in appModel.locationList ) {
		NSLog(@"GPSViewController: Adding location name:%@ id:%d", location.name, location.locationId);
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

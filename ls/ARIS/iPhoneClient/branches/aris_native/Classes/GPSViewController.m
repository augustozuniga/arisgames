//
//  GPSViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "GPSViewController.h"
#import "RMMapView.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"
#import "Location.h"

@implementation GPSViewController

@synthesize mapView;
@synthesize moduleName;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	moduleName = @"RESTMap";
	
	//register for notifications
	NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
	[dispatcher addObserver:self selector:@selector(setMarkersFromLocationList:) name:@"ReceivedLocationList" object:nil];
	[dispatcher addObserver:self selector:@selector(movePlayerMarker:) name:@"PlayerMoved" object:nil];

	CGFloat tableViewHeight = 416; // todo: get this from const
	CGRect mainViewBounds = self.view.bounds;
	CGRect tableFrame;
	tableFrame = CGRectMake(CGRectGetMinX(mainViewBounds),
							CGRectGetMinY(mainViewBounds),
							CGRectGetWidth(mainViewBounds),
							tableViewHeight);
	mapView = [[RMMapView alloc] initWithFrame:tableFrame];    
	[webView addSubview:mapView];
	
	markerManager = [mapView markerManager];
	
	//Set up the Player Marker and Center the Map on them
	CLLocationCoordinate2D playerPosition;
	playerPosition.latitude = [appModel.lastLatitude floatValue];
	playerPosition.longitude = [appModel.lastLongitude floatValue];
	
	playerMarker = [[RMMarker alloc]initWithCGImage:[RMMarker loadPNGFromBundle:@"marker-blue"]];
	[playerMarker setTextLabel:@"You"];
	[markerManager addMarker:playerMarker AtLatLong:playerPosition];
	[[mapView contents] moveToLatLong:playerPosition];
	
	NSLog(@"GPS View Loaded");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

-(void) setModel:(AppModel *)model {
	if(appModel != model) {
		[appModel release];
		appModel = model;
		[appModel retain];
	}
	NSLog(@"model set for GPS");
	
	[self updateLocations];
}




// Sets up the map with markers and centering.
- (void) updateLocations {
	//Move the player marker
	CLLocationCoordinate2D playerPosition;
	playerPosition.latitude = [appModel.lastLatitude floatValue];
	playerPosition.longitude = [appModel.lastLongitude floatValue];
	
	[markerManager moveMarker:playerMarker AtLatLon: playerPosition];
	[[mapView contents] moveToLatLong:playerPosition];
		
	//Ask for the Locations to be loaded into the model
	[appModel fetchLocationList];
}

- (void)movePlayerMarker:(NSNotification *)notification {
	//Move the player marker
	CLLocationCoordinate2D playerPosition;
	playerPosition.latitude = [appModel.lastLatitude floatValue];
	playerPosition.longitude = [appModel.lastLongitude floatValue];
	
	[markerManager moveMarker:playerMarker AtLatLon: playerPosition];
	[[mapView contents] moveToLatLong:playerPosition];
	
}

- (void)setMarkersFromLocationList:(NSNotification *)notification {
	NSDictionary *userInfo = notification.userInfo;
	NSMutableArray *locationList = [userInfo objectForKey:@"locationList"];
	
	//Blow away the old markers in the markerManager
	[markerManager removeMarkers];
	
	//Add the player marker back in
	[markerManager addMarker:playerMarker];
	
	//Add the freshly loaded locations from the notification
	for ( Location* location in locationList ) {
		CLLocationCoordinate2D locationLatLong;
		locationLatLong.latitude = [location.latitude floatValue];
		locationLatLong.longitude = [location.longitude floatValue];

		RMMarker *locationMarker = [[RMMarker alloc]initWithCGImage:[RMMarker loadPNGFromBundle:@"marker-blue"]];
		[locationMarker setTextLabel:location.name];
		[markerManager addMarker:locationMarker AtLatLong:locationLatLong];
		[locationMarker release];
		
	}
	NSLog(@"Recieved Location List on GPS controller!!");
}

- (void)dealloc {
	[appModel release];
	[moduleName release];
    [super dealloc];
}


@end

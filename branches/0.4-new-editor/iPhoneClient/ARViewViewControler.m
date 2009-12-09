//
//  ARViewViewControler.m
//  ARIS
//
//  Created by David J Gagnon on 12/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ARViewViewControler.h"
#import "AsyncImageView.h"
#import "NearbyObjectARCoordinate.h"
#import "Location.h"


@implementation ARViewViewControler

@synthesize locations;

//Override init for passing title and icon to tab bar
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        self.title = @"AR View PT";
        self.tabBarItem.image = [UIImage imageNamed:@"camera.png"];
		appModel = [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	
	ARGeoViewController *viewController = [[ARGeoViewController alloc] init];
	viewController.debugMode = NO;
	viewController.delegate = self;
	viewController.scaleViewsBasedOnDistance = NO;
	viewController.minimumScaleFactor = .5;
	viewController.rotateViewsBasedOnPerspective = NO;

	
	//Init with the nearby locations in the model
	NSMutableArray *tempLocationArray = [[NSMutableArray alloc] initWithCapacity:10];
	
	NearbyObjectARCoordinate *tempCoordinate;
	for ( Location *nearbyLocation in appModel.nearbyLocationsList ) {		
		tempCoordinate = [NearbyObjectARCoordinate coordinateWithNearbyLocation: nearbyLocation];
		[tempLocationArray addObject:tempCoordinate];
		NSLog(@"ARViewViewController: Added %@", tempCoordinate.title);
	}
	
	
	/* Example point being added
	CLLocation *tempLocation;
	ARGeoCoordinate *tempCoordinate;
	tempLocation = [[CLLocation alloc] initWithCoordinate:location altitude:1609.0 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:[NSDate date]];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Denver";
	[tempLocationArray addObject:tempCoordinate];
	*/
	
	
	[viewController addCoordinates:tempLocationArray];
		
	viewController.centerLocation = appModel.playerLocation;
	
	[viewController startListening];
	
	[[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:viewController.view];
	
    // Override point for customization after application launch
    [[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];	
	
	[super viewDidLoad];
	NSLog(@"ARView Loaded");
}


#define BOX_WIDTH 300
#define BOX_HEIGHT 320

- (UIView *)viewForCoordinate:(NearbyObjectARCoordinate *)coordinate {
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
		
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = coordinate.title;
	[titleLabel sizeToFit];
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, 0, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	
	
	AsyncImageView *pointView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
	pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - 300 / 2.0), 20, 300, 300);
	if (coordinate.mediaId != 0) {
		 Media *pointMedia = [appModel.mediaList objectForKey:[NSNumber numberWithInt:coordinate.mediaId]];
		 [pointView loadImageFromMedia:pointMedia];
	}
	else pointView.image = [UIImage imageNamed:@"location.png"];

	
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
	
	[titleLabel release];
	[pointView release];
	
	return [tempView autorelease];
}

- (void)refresh {
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

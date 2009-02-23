//
//  ARISAppDelegate.m
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright University of Wisconsin 2009. All rights reserved.
//

#import "ARISAppDelegate.h"
#import "model/Game.h"

//private
@interface ARISAppDelegate (hidden)

-(void) contractTabBar;
-(void) expandTabBar;

@end

//impl
@implementation ARISAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize loginViewController;
@synthesize toolbarViewController;
@synthesize gamePickerViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//init app model
	appModel = [[AppModel alloc] init];
	appModel.baseAppURL = @"http://localhost/aris/src/index.php";
	appModel.site = @"Default";
	[appModel retain];

	//register for notifications from views
	NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
	[dispatcher addObserver:self selector:@selector(performUserLogin:) name:@"PerformUserLogin" object:nil];
	[dispatcher addObserver:self selector:@selector(selectGame:) name:@"SelectGame" object:nil];
	[dispatcher addObserver:self selector:@selector(setGameList:) name:@"ReceivedGameList" object:nil];
	
	//set frame rect of Tabbar view to sit below title/nav bar
	[self contractTabBar];
	
	UIView *tableView = gamePickerViewController.view;
	tableView.frame = CGRectMake(0.0f, 485.0f, 320.0f, 416.0f);
	
    // Add the tab bar controller's current view as a subview of the window
	[window addSubview:toolbarViewController.view];
	[window addSubview:tabBarController.view];
	[window addSubview:loginViewController.view];
	[window addSubview:gamePickerViewController.view];
	
	UINavigationController *moreNavController = tabBarController.moreNavigationController;
	//customize the more nav controller
	moreNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	moreNavController.delegate = self;
	
	//make sure first view controller in tab has model set
	UIViewController *selViewController = [tabBarController selectedViewController];
	[selViewController performSelector:@selector(setModel:) withObject:appModel];
	
	//Setup MyCLController
	myCLController = [[MyCLController alloc] init];
	myCLController.delegate = self;
	[myCLController.locationManager startUpdatingLocation];
}

// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabController didSelectViewController:(UIViewController *)viewController {
	//NSLog(@"GOT TAB DELEGATE");
	if(tabBarController.selectedIndex == 4) {
		[self expandTabBar];
	} else if(tabBarController.selectedIndex < 4) {
		//navController = 
		[self contractTabBar];
		[toolbarViewController setToolbarTitle:viewController.title];
	}
	
	if([viewController respondsToSelector:@selector(setModel:)]) {
		[viewController performSelector:@selector(setModel:) withObject:appModel];
	}
	
	UINavigationController *navController = viewController.navigationController;
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

#pragma mark navigation controller delegate
- (void)navigationController:(UINavigationController *)navigationController 
		didShowViewController:(UIViewController *)viewController 
		animated:(BOOL)animated {
	
	if([viewController class] == [gamePickerViewController class]) {
		[viewController performSelector:@selector(setGameList:) withObject:appModel.gameList];
	}
	
	if([viewController respondsToSelector:@selector(setModel:)]) {
		[viewController performSelector:@selector(setModel:) withObject:appModel];
	}
}

# pragma mark custom methods, notification handlers

- (void)contractTabBar {
	UIView *tabBar = tabBarController.view;
	tabBar.frame = CGRectMake(0.0f, 64.0f, 320.0f, 416.0f);
}

- (void)expandTabBar {
	UIView *tabBar = tabBarController.view;
	tabBar.frame = CGRectMake(0.0f, 20.0f, 320.0f, 460.0f);
}

- (void)performUserLogin:(NSNotification *)notification {
    //NSDictionary *loginObject = [notification object];
	NSDictionary *userInfo = notification.userInfo;
	
	NSLog(@"CAUGHT PERFORM LOGIN, username:");
	NSLog([userInfo objectForKey:@"username"]);
	NSLog(@"password:");
	NSLog([userInfo objectForKey:@"password"]);
	
	appModel.username = [userInfo objectForKey:@"username"];
	appModel.password = [userInfo objectForKey:@"password"];
	BOOL loginSuccessful = [appModel login];
	NSLog([appModel description]);
	//handle login response
	if(loginSuccessful) {
		NSLog(@"login success");
		[loginViewController setNavigationTitle:@"Select a Game"];
		gamePickerViewController.view.hidden = NO;
		[appModel fetchGameList];
		//[gamePickerViewController slideIn];
	} else {
		NSLog(@"login fail");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Invalid username or password."
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	
}

- (void)selectGame:(NSNotification *)notification {
    //NSDictionary *loginObject = [notification object];
	NSDictionary *userInfo = notification.userInfo;
	Game *selectedGame = [userInfo objectForKey:@"game"];
	
	NSLog(@"CAUGHT Select game, game name:");
	NSLog(selectedGame.name);
	
	//do different depending on where we're coming from
	if(loginViewController.view.hidden == NO) {
		[gamePickerViewController slideOut];
		loginViewController.view.hidden = YES;
	}
	
	//change tab bar selected index
	tabBarController.selectedIndex = 0;
	
	//Set the model to this game
	appModel.site = selectedGame.name;
	
	//Load the default module, TODO
	appModel.currentModule = @"TODO";
}

- (void)setGameList:(NSNotification *)notification {
    //NSDictionary *loginObject = [notification object];
	NSDictionary *userInfo = notification.userInfo;
	NSMutableArray *gameList = [userInfo objectForKey:@"gameList"];
	NSLog(@"SETTING Game List on controller!!");
	[gamePickerViewController setGameList:gameList];
	[gamePickerViewController slideIn];
}

- (void)dealloc {
	[appModel release];
	[webView release];
	[myCLController release];
	[toolbarViewController release];
    [tabBarController release];
	[loginViewController release];
	[gamePickerViewController release];
    [window release];
    [super dealloc];
}

#pragma mark --- Delegate methods for MyCLController ---
- (void)updateLatitude: (NSString *)latitude andLongitude:(NSString *) longitude {
	// Check if we're updating locations, and then update the label, too.
	if (appModel.lastLatitude != nil) [appModel.lastLatitude dealloc];
	if (appModel.lastLongitude != nil) [appModel.lastLongitude dealloc];
	appModel.lastLatitude = [latitude copy];
	appModel.lastLongitude = [longitude copy];
	
	
	//Call the update_location() js function on the game
	NSLog(@"Updating location: %@, %@", appModel.lastLatitude, appModel.lastLongitude);
	if ([webView stringByEvaluatingJavaScriptFromString:
		 [NSString stringWithFormat:@"%@/update_location(%@, %@);", appModel.baseAppURL, appModel.lastLatitude, appModel.lastLongitude]] == nil)
	{
		NSLog(@"Couldn't execute script!");
	}
	else NSLog(@"update_location() executed successfully.");

}

- (void)newError: (NSString *)text {
	NSLog(text);
}

@end


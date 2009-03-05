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
	appModel.baseAppURL = @"http://davembp.local/aris/src/index.php";
	appModel.site = @"Default";
	[appModel loadUserDefaults];
	[appModel retain];

	//register for notifications from views
	NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
	[dispatcher addObserver:self selector:@selector(performUserLogin:) name:@"PerformUserLogin" object:nil];
	[dispatcher addObserver:self selector:@selector(selectGame:) name:@"SelectGame" object:nil];
	[dispatcher addObserver:self selector:@selector(setGameList:) name:@"ReceivedGameList" object:nil];
	[dispatcher addObserver:self selector:@selector(performLogout:) name:@"LogoutRequested" object:nil];
	
	//set frame rect of Tabbar view to sit below title/nav bar
	[self contractTabBar];
	
	UIView *tableView = gamePickerViewController.view;
	tableView.frame = CGRectMake(0.0f, 485.0f, 320.0f, 416.0f);
	
    // Add the tab bar controller's current view as a subview of the window
	[window addSubview:toolbarViewController.view];
	[window addSubview:tabBarController.view];	

	
	//Display the login screen if this user is not logged in
	if (appModel.loggedIn == YES) {
		[appModel fetchGameList];
		if (appModel.site == @"Default") {
			NSLog(@"Player already logged in, but a site has not been selected. Display site picker");
			[window addSubview:gamePickerViewController.view];
		}
		else NSLog(@"Player already logged in and they have a site selected. Go into the defualt module");
	}
	else {
		NSLog(@"Player not logged in, display login");
		[window addSubview:loginViewController.view];
	}
	
	
	
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
		[loginViewController.view removeFromSuperview];
		[window addSubview:gamePickerViewController.view];
		[appModel fetchGameList];
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

	[gamePickerViewController.view removeFromSuperview];
	
	//change tab bar selected index
	tabBarController.selectedIndex = 0;
	
	//Set the model to this game
	appModel.site = selectedGame.name;
	
	//Set User Defaults for next Load
	NSLog(@"Saving Site Info in User Defaults");
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	[defaults setObject:appModel.site forKey:@"site"];
	[defaults release];
	
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

- (void)performLogout:(NSNotification *)notification {
    NSLog(@"Performing Logout: Clearing NSUserDefaults and Displaying Login Screen");
	
	//Clear NSUserDefaults
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	[defaults removeObjectForKey:@"loggedIn"];	
	[defaults release];
	
	
	//(re)load the login view
	[window addSubview:loginViewController.view];
	loginViewController.view.hidden == NO;
}

#pragma mark --- Delegate methods for MyCLController ---
- (void)updateLatitude: (NSString *)latitude andLongitude:(NSString *) longitude {
	
	appModel.lastLatitude = [latitude copy];
	appModel.lastLongitude = [longitude copy];
	
	//Tell the Server - Call the update_location() js function on the game
	NSLog(@"Updating location: %@, %@", appModel.lastLatitude, appModel.lastLongitude);
	if ([webView stringByEvaluatingJavaScriptFromString:
		 [NSString stringWithFormat:@"%@/update_location(%@, %@);", appModel.baseAppURL, appModel.lastLatitude, appModel.lastLongitude]] == nil)
	{
		NSLog(@"Couldn't execute script!");
	}
	else NSLog(@"update_location() executed successfully.");
	
	//Tell the client
	NSNotification *updatedLocationNotification = [NSNotification notificationWithName:@"PlayerMoved" object:self];
	[[NSNotificationCenter defaultCenter] postNotification:updatedLocationNotification];
}

- (void)newError: (NSString *)text {
	NSLog(text);
}

- (void)dealloc {
	[appModel release];
	[super dealloc];
}
@end


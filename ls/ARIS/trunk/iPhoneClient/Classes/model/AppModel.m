//
//  AppModel.m
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "AppModel.h"
#import "GameListParserDelegate.h"
#import "LocationListParserDelegate.h"
#import "NearbyLocationsListParserDelegate.h"
#import "InventoryParserDelegate.h"

#import "Item.h"
#import "XMLParserDelegate.h"


@implementation AppModel

NSDictionary *InventoryElements;

@synthesize serverName;
@synthesize baseAppURL;
@synthesize loggedIn;
@synthesize username;
@synthesize password;
@synthesize currentModule;
@synthesize site;
@synthesize gameList;
@synthesize locationList;
@synthesize nearbyLocationsList;
@synthesize lastLocation;
@synthesize inventory;

-(id)init {
    if (self = [super init]) {
		//Init USerDefaults
		defaults = [NSUserDefaults standardUserDefaults];
		
		//Init Inventory XML Parsing info
		if (InventoryElements == nil) {	
			InventoryElements = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNull null], @"result",
								 [NSNull null], @"frameworkTplPath",
								 [NSNull null], @"isIphone",
								 [NSNull null], @"site",
								 [NSNull null], @"title",
								 [NSNull null], @"inventory",
			 [NSDictionary dictionaryWithObjectsAndKeys:
			  [Item class], @"__CLASS_NAME",
			  @"setItemId:", @"item_id",
			  @"setName:", @"name",
			  @"setDescription:", @"description",
			  @"setType:", @"type",
			  @"setMediaURL:", @"media",
			  @"setIconURL:", @"icon",
			  nil
			  ], @"row", 
			nil];
			[InventoryElements retain];
		}
		NSLog(@"Testing InventoryElements nilp? %@", InventoryElements);
	}
			 
    return self;
}


-(void)loadUserDefaults {
	NSLog(@"Model: Loading User Defaults");
	
	//Load the base App URL and calculate the serverName (we should move the calculation to a geter)
	self.baseAppURL = [defaults stringForKey:@"baseAppURL"];
	NSURL *url = [NSURL URLWithString:self.baseAppURL];
	self.serverName = [NSString stringWithFormat:@"http://%@:%@", [url host], [url port]];
	
	self.site = [defaults stringForKey:@"site"];
	self.loggedIn = [defaults boolForKey:@"loggedIn"];
	
	if (loggedIn == YES) {
		if (![baseAppURL isEqualToString:[defaults stringForKey:@"lastBaseAppURL"]]) {
			self.loggedIn = NO;
			self.site = @"Default";
			NSLog(@"Model: Server URL changed since last execution. Throw out Defaults and use URL: '%@' Site: '%@'", baseAppURL, site);
		}
		else {
			self.username = [defaults stringForKey:@"username"];
			self.password = [defaults stringForKey:@"password"];
			NSLog(@"Model: Defaults Found. Use URL: '%@' User: '%@' Password: '%@' Site: '%@'", baseAppURL, username, password, site);
		}
	}
	else NSLog(@"Model: No default User Data to Load. Use URL: '%@' Site: '%@'", baseAppURL, site);
}


-(void)clearUserDefaults {
	NSLog(@"Model: Clearing User Defaults");
	
	[defaults removeObjectForKey:@"loggedIn"];	
	[defaults removeObjectForKey:@"username"];
	[defaults removeObjectForKey:@"password"];
	//Don't clear the baseAppURL
	[defaults setObject:@"Default" forKey:@"site"];

}


-(void)saveUserDefaults {
	NSLog(@"Model: Saving User Defaults");
	
	[defaults setBool:loggedIn forKey:@"loggedIn"];
	[defaults setObject:username forKey:@"username"];
	[defaults setObject:password forKey:@"password"];
	[defaults setObject:baseAppURL forKey:@"lastBaseAppURL"];
	[defaults setObject:site forKey:@"site"];
}


-(void)initUserDefaults {
	NSDictionary *initDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
								  @"http://atsosxdev.doit.wisc.edu/aris/games", @"baseAppURL",
								  @"Default", @"site",
								  nil];

	[defaults registerDefaults:initDefaults];
}


- (BOOL)login {
	BOOL loginSuccessful = NO;
	
	//Piece together URL
	NSURLRequest *keyRequest = [self getURLForModule:@"RESTLogin"];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURLResponse *response = NULL;
	NSData *loginData = [NSURLConnection sendSynchronousRequest:keyRequest returningResponse:&response error:NULL];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSString *loginResponse = [[NSString alloc] initWithData:loginData encoding:NSASCIIStringEncoding];
	
	//handle login response
	if([loginResponse isEqual:@"1"]) {
		loginSuccessful = YES;
	}
	
	loggedIn = loginSuccessful;
	
	return loginSuccessful;
}


-(NSURLRequest *)getURLForModule:(NSString *)moduleName {
	NSString *urlString = [self getURLStringForModule:moduleName];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
												cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:60.0];
	return urlRequest;
}


-(NSString *)getURLStringForModule:(NSString *)moduleName {
	return [[[NSString alloc] initWithFormat:@"%@?module=%@&site=%@&user_name=%@&password=%@",
							baseAppURL, moduleName, site, username, password] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}


-(NSString *) getURLString:(NSString *)relativeURL {
	return [[[NSString alloc] initWithFormat:@"%@%@", serverName, relativeURL]  stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}


- (void)fetchGameList {
	//init location list array
	if(gameList != nil) {
		[gameList release];
	}
	gameList = [NSMutableArray array];
	[gameList retain];
	
	//init url
	NSString *urlString = [NSString stringWithFormat:@"%@?module=RESTSelectGame&user_name=%@&password=%@",
									baseAppURL, username, password];
	NSLog(@"Fetching Game List from: %@", urlString );

	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
	GameListParserDelegate *gameListParserDelegate = [[GameListParserDelegate alloc] initWithGameList:gameList];
	
	[parser setDelegate:gameListParserDelegate];
	
	//init parser
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	[parser release];
}


- (void)fetchLocationList {
	//init location list array
	if(locationList != nil) {
		[locationList release];
	}
	locationList = [NSMutableArray array];
	[locationList retain];
	
	//init url
	NSString *urlString = [NSString stringWithFormat:@"%@?module=RESTMap&site=%@&user_name=%@&password=%@",
						   baseAppURL, site, username, password];
	NSLog([NSString stringWithFormat:@"Fetching All Locations from : %@", urlString]);
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
	
	LocationListParserDelegate *locationListParserDelegate = [[LocationListParserDelegate alloc] initWithLocationList:locationList];
	[parser setDelegate:locationListParserDelegate];
	
	//init parser
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	[parser release];
}


- (void)fetchInventory {
	NSLog(@"Model: Inventory Fetch Requested");
	//init inventory array
	if(inventory != nil) {
		NSLog(@"*** Releasing inventory ***");
		[inventory release];
	}

	inventory = [NSMutableArray array];
	[inventory retain];
	
	//init url
	NSString *urlString = [self getURLStringForModule:@"Inventory&controller=SimpleREST"];	
	NSLog([NSString stringWithFormat:@"Fetching Inventory from : %@", urlString]);
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
	
	XMLParserDelegate *parserDelegate = [[XMLParserDelegate alloc] initWithDictionary:InventoryElements
																		   andResults:inventory forNotification:@"ReceivedInventory"];
	[parser setDelegate:parserDelegate];
	
	//init parser
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	[parser release];
}


- (void)updateServerLocationAndfetchNearbyLocationList {
	//init a fresh nearby location list array
	if(nearbyLocationsList != nil) {
		[nearbyLocationsList release];
	}
	nearbyLocationsList = [NSMutableArray array];
	[nearbyLocationsList retain];
	
	//init url
	NSString *urlString = [NSString stringWithFormat:@"%@?module=RESTAsync&site=%@&user_name=%@&password=%@&latitude=%f&longitude=%f",
						   baseAppURL, site, username, password, lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
	
	NSLog([NSString stringWithFormat:@"Fetching Nearby Locations from : %@", urlString]);
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
	
	NearbyLocationsListParserDelegate *nearbyLocationsListParserDelegate = [[NearbyLocationsListParserDelegate alloc] initWithNearbyLocationsList:nearbyLocationsList];
	[parser setDelegate:nearbyLocationsListParserDelegate];
	//init parser
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	[parser release];
}



- (void)dealloc {
	[gameList release];
	[baseAppURL release];
	[username release];
	[password release];
	[currentModule release];
	[site release];
	[InventoryElements release];
    [super dealloc];
}

@end

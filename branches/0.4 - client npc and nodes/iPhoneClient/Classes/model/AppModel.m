//
//  AppModel.m
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "AppModel.h"

#import "LocationListParserDelegate.h"
#import "NearbyLocationsListParserDelegate.h"

#import "XMLParserDelegate.h"
#import "ARISAppDelegate.h"

#import "Item.h"
#import "JSONConnection.h"
#import "JSONResult.h"
#import "JSON.h"



static NSString *nearbyLock = @"nearbyLock";
static NSString *locationsLock = @"locationsLock";

@implementation AppModel

NSDictionary *InventoryElements;

@synthesize serverName;
@synthesize baseAppURL;
@synthesize jsonServerBaseURL;
@synthesize loggedIn;
@synthesize username;
@synthesize password;
@synthesize playerId;
@synthesize currentModule;
@synthesize site;
@synthesize gameId;
@synthesize gameList;
@synthesize locationList;
@synthesize playerList;
@synthesize lastLocation;
@synthesize inventory;
@synthesize networkAlert;

@dynamic nearbyLocationsList;

-(id)init {
    if (self = [super init]) {
		//Init USerDefaults
		defaults = [NSUserDefaults standardUserDefaults];
		
		jsonServerBaseURL = @"http://davembp.local/editor/server/json.php/aris";
		
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
			  @"setDropable:", @"dropable",
			  @"setDestroyable:", @"destroyable",
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
	
	//Make sure it has a trailing slash (needed in some places)
	int length = [self.baseAppURL length];
	unichar lastChar = [self.baseAppURL characterAtIndex:length-1];
	NSString *lastCharString = [ NSString stringWithCharacters:&lastChar length:1 ];
	if (![lastCharString isEqualToString:@"/"]) self.baseAppURL = [[NSString alloc] initWithFormat:@"%@/",self.baseAppURL];
	
	NSURL *url = [NSURL URLWithString:self.baseAppURL];
	self.serverName = [NSString stringWithFormat:@"http://%@:%d", [url host], 
					   ([url port] ? [[url port] intValue] : 80)];
	
	self.site = [defaults stringForKey:@"site"];
	self.gameId = [defaults integerForKey:@"gameId"];
	self.loggedIn = [defaults boolForKey:@"loggedIn"];
	
	if (loggedIn == YES) {
		if (![baseAppURL isEqualToString:[defaults stringForKey:@"lastBaseAppURL"]]) {
			self.loggedIn = NO;
			self.site = @"Default";
			NSLog(@"Model: Server URL changed since last execution. Throw out Defaults and use URL: '%@' Site: '%@' GameId: '%d'", baseAppURL, site, gameId);
		}
		else {
			self.username = [defaults stringForKey:@"username"];
			self.password = [defaults stringForKey:@"password"];
			self.playerId = [defaults integerForKey:@"playerId"];
			NSLog(@"Model: Defaults Found. Use URL: '%@' User: '%@' Password: '%@' PlayerId: '%d' GameId: '%d' Site: '%@'", baseAppURL, username, password, playerId, gameId, site);
		}
	}
	else NSLog(@"Model: No default User Data to Load. Use URL: '%@' Site: '%@'", baseAppURL, site);
}


-(void)clearUserDefaults {
	NSLog(@"Model: Clearing User Defaults");
	
	[defaults removeObjectForKey:@"loggedIn"];	
	[defaults removeObjectForKey:@"username"];
	[defaults removeObjectForKey:@"password"];
	[defaults removeObjectForKey:@"playerId"];
	[defaults removeObjectForKey:@"gameId"];
	//Don't clear the baseAppURL
	[defaults setObject:@"Default" forKey:@"site"];

}


-(void)saveUserDefaults {
	NSLog(@"Model: Saving User Defaults");
	
	[defaults setBool:loggedIn forKey:@"loggedIn"];
	[defaults setObject:username forKey:@"username"];
	[defaults setObject:password forKey:@"password"];
	[defaults setInteger:playerId forKey:@"playerId"];
	[defaults setInteger:gameId forKey:@"gameId"];
	[defaults setObject:baseAppURL forKey:@"lastBaseAppURL"];
	[defaults setObject:site forKey:@"site"];
	[defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVerison"];
	
}


-(void)initUserDefaults {	
	NSDictionary *initDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
								  @"http://arisgames.org/engine/", @"baseAppURL",
								  @"Default", @"site",
								  nil];

	[defaults registerDefaults:initDefaults];
}

#pragma mark Communication with Server

- (BOOL)login {
	BOOL loginSuccessful;	
	NSArray *arguments = [NSArray arrayWithObjects:self.username, self.password, nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName: @"players" 
																	andMethodName:@"login"
																	andArguments:arguments]; 

	JSONResult *jsonResult = [jsonConnection performSynchronousRequest];
	
	//handle login response
	int returnCode = jsonResult.returnCode;
	NSLog(@"AppModel: Login Result Code: %d", returnCode);
	if(returnCode == 0) {
		loginSuccessful = YES;
		loggedIn = YES;
		playerId = [((NSDecimalNumber*)jsonResult.data) intValue];
	}
	else {
		loginSuccessful = NO;	
	}
	
	self.loggedIn = loginSuccessful;
	return loginSuccessful;
}


- (void)fetchGameList {
	NSLog(@"AppModel: Fetching Game List.");
	
	//Call server service
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"games" 
																	 andMethodName:@"getGames" andArguments:nil];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
	
	
	//Build the game list
	NSMutableArray *tempGameList = [[NSMutableArray alloc] init];
	NSEnumerator *gamesEnumerator = [((NSArray *)jsonResult.data) objectEnumerator];	
	NSDictionary *gameDictionary;
	while (gameDictionary = [gamesEnumerator nextObject]) {
		//create a new game
		Game *game = [[Game alloc] init];
		game.gameId = [gameDictionary valueForKey:@"game_id"];
		game.name = [gameDictionary valueForKey:@"name"];
		NSString *prefix = [gameDictionary valueForKey:@"prefix"];
		//parse out the trailing _ in the prefix
		game.site = [prefix substringToIndex:[prefix length] - 1];
		NSLog(@"Model: Adding Game: %@", game.name);
		[tempGameList addObject:game]; 
	}
	
	self.gameList = [NSArray arrayWithArray:tempGameList];
	
	//Tell everyone
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.gameList forKey:@"gameList"];
	NSLog(@"GameListParser: Finished Building the Game List");
	NSNotification *notification = [NSNotification notificationWithName:@"ReceivedGameList" object:self userInfo:dictionary];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
	
}

- (void)fetchLocationList {
	@synchronized (nearbyLock) {
	
		NSLog(@"Fetching All Locations.");	
		
		//init location list array
		if(locationList != nil) {
			[locationList release];
		}
		locationList = [NSMutableArray array];
		[locationList retain];
	
		//init player list array
		if(playerList != nil) {
			[playerList release];
		}
		playerList = [NSMutableArray array];
		[playerList retain];
	
	
		//Fetch Data
		NSURLRequest *request = [self getURLForModule:@"RESTMap"];
		NSData *data = [self fetchURLData:request];
	
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
		LocationListParserDelegate *locationListParserDelegate = [[LocationListParserDelegate alloc] initWithModel:self];
		[parser setDelegate:locationListParserDelegate];
	
		//init parser
		[parser setShouldProcessNamespaces:NO];
		[parser setShouldReportNamespacePrefixes:NO];
		[parser setShouldResolveExternalEntities:NO];
		[parser parse];
		[parser release];
	}
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
		
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [[NSNumber numberWithInt:self.gameId] stringValue], [[NSNumber numberWithInt:self.playerId] stringValue], nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"items" 
																	 andMethodName:@"getItemsForPlayer" andArguments:arguments];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
	
	//Build the inventory
	NSMutableArray *tempInventory = [[NSMutableArray alloc] init];
	NSEnumerator *inventoryEnumerator = [((NSArray *)jsonResult.data) objectEnumerator];	
	NSDictionary *itemDictionary;
	while (itemDictionary = [inventoryEnumerator nextObject]) {
		Item *item = [[Item alloc] init];
		item.itemId = [itemDictionary valueForKey:@"item_id"];
		item.name = [itemDictionary valueForKey:@"name"];
		item.type = [itemDictionary valueForKey:@"type"];
		item.description = [itemDictionary valueForKey:@"description"];
		item.mediaURL = [itemDictionary valueForKey:@"media"];
		item.iconURL = [itemDictionary valueForKey:@"icon"];
		item.dropable = [itemDictionary valueForKey:@"dropable"];
		item.destroyable = [itemDictionary valueForKey:@"destroyable"];
		NSLog(@"Model: Adding Item: %@", item.name);
		[tempInventory addObject:item]; 
	}
	
	self.inventory = [NSArray arrayWithArray:tempInventory];
	
	NSNotification *notification = [NSNotification notificationWithName:@"ReceivedInventory" object:self userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}


- (void)updateServerLocationAndfetchNearbyLocationList {
	@synchronized (nearbyLock) {
		//init a fresh nearby location list array
		if(nearbyLocationsList != nil) {
			[nearbyLocationsList release];
		}
		nearbyLocationsList = [NSMutableArray array];
		[nearbyLocationsList retain];
	
		//Fetch Data
		NSURLRequest *request = [self getURLForModule:
								 [NSString stringWithFormat:@"RESTAsync&latitude=%f&longitude=%f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude]];
		NSData *data = [self fetchURLData:request];	
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];	
	
		NearbyLocationsListParserDelegate *nearbyLocationsListParserDelegate = [[NearbyLocationsListParserDelegate alloc] initWithNearbyLocationsList:nearbyLocationsList];
		[parser setDelegate:nearbyLocationsListParserDelegate];
		
		//init parser
		[parser setShouldProcessNamespaces:NO];
		[parser setShouldReportNamespacePrefixes:NO];
		[parser setShouldResolveExternalEntities:NO];
		[parser parse];
		[parser release];
	}
}


#pragma mark Syncronizers

- (NSMutableArray *)nearbyLocationsList {
	NSMutableArray *result = nil;
	@synchronized (nearbyLock) {
		result = [nearbyLocationsList retain];
	}
	return result;
}

- (void)setNearbyLocationList:(NSMutableArray *)source {
	@synchronized (nearbyLock) {
		nearbyLocationsList = [source copy];
	}
}



- (NSMutableArray *)locationList {
	NSMutableArray *result = nil;
	@synchronized (locationsLock) {
		result = [locationList retain];
	}
	return result;
}

- (void)setLocationList:(NSMutableArray *)source {
	@synchronized (locationsLock) {
		locationList = [source copy];
	}
}


- (NSMutableArray *)playerList {
	NSMutableArray *result = nil;
	@synchronized (locationsLock) {
		result = [playerList retain];
	}
	return result;
}

- (void)setPlayerList:(NSMutableArray *)source {
	@synchronized (locationsLock) {
		playerList = [source copy];
	}
}




#pragma mark Old Engine Helper Functions
//Returns the complete URL for the module, including authentication
-(NSMutableURLRequest *)getURLForModule:(NSString *)moduleName {
	NSString *urlString = [self getURLStringForModule:moduleName];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:15.0];
	return urlRequest;
}

//Returns the complete URL for the module, including authentication
-(NSString *)getURLStringForModule:(NSString *)moduleName {
	NSString *URLString = [[[NSString alloc] initWithFormat:@"%@?module=%@&site=%@&user_name=%@&password=%@",
							baseAppURL, moduleName, site, username, password] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSLog(@"Model: URL String for Module was = %@",URLString);
	return URLString;
}

//Returns the complete URL for the server
-(NSMutableURLRequest *)getURL:(NSString *)relativeURL {
	NSString *urlString = [self getURLString:relativeURL];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:15.0];
	return urlRequest;
}

//Returns the complete URL for the server
-(NSString *) getURLString:(NSString *)relativeURL {
	NSString *URLString = [[[NSString alloc] initWithFormat:@"%@%@", serverName, relativeURL]  stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSLog(@"Model: URL String for Module was = %@",URLString);
	return URLString;
}

//Returns the complete URL including the engine path
-(NSMutableURLRequest *)getEngineURL:(NSString *)relativeURL {
	NSString *urlString = [self getEngineURLString:relativeURL];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:15.0];
	return urlRequest;
}

//Returns the complete URL including the engine path
-(NSString *) getEngineURLString:(NSString *)relativeURL {
	NSString *URLString = [[[NSString alloc] initWithFormat:@"%@/%@", baseAppURL, relativeURL]  stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSLog(@"Model: URL String for Module was = %@",URLString);
	return URLString;
}



-(NSData *) fetchURLData: (NSURLRequest *)request {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSURLResponse *response = NULL;
	NSError *error = NULL;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if (error != NULL) [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showNetworkAlert];	
	else [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] removeNetworkAlert];
	return data;
}


#pragma mark Memory Management

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

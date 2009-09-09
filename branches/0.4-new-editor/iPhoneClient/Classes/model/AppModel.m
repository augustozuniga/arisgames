//
//  AppModel.m
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "AppModel.h"
#import "ARISAppDelegate.h"

#import "NodeOption.h"
#import "Quest.h"


#import "JSONConnection.h"
#import "JSONResult.h"
#import "JSON.h"



static NSString *nearbyLock = @"nearbyLock";
static NSString *locationsLock = @"locationsLock";

@implementation AppModel

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
@synthesize playerLocation;
@synthesize inventory;
@synthesize questList;
@synthesize networkAlert;

@dynamic nearbyLocationsList;

-(id)init {
    if (self = [super init]) {
		//Init USerDefaults
		defaults = [NSUserDefaults standardUserDefaults];
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
			NSLog(@"Model: Defaults Found. Use URL: '%@' User: '%@' Password: '%@' PlayerId: '%d' GameId: '%d' Site: '%@'", 
				  baseAppURL, username, password, playerId, gameId, site);
		}
	}

	else NSLog(@"Model: No default User Data to Load. Use URL: '%@' Site: '%@'", baseAppURL, site);
	
	
	self.jsonServerBaseURL = [NSString stringWithFormat:@"%@%@",
						 baseAppURL, @"json.php/aris"];
	
	NSLog(@"AppModel: jsonServerURL is %@",jsonServerBaseURL);
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
	NSLog(@"AppModel: Login Requested");
	NSArray *arguments = [NSArray arrayWithObjects:self.username, self.password, nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithArisJSONServer:jsonServerBaseURL 
																	andServiceName: @"players" 
																	andMethodName:@"login"
																	andArguments:arguments]; 

	JSONResult *jsonResult = [jsonConnection performSynchronousRequest];
	
	if (!jsonResult) {
		self.loggedIn = NO;
		return NO;
	}
	
	//handle login response
	int returnCode = jsonResult.returnCode;
	NSLog(@"AppModel: Login Result Code: %d", returnCode);
	if(returnCode == 0) {
		self.loggedIn = YES;
		loggedIn = YES;
		playerId = [((NSDecimalNumber*)jsonResult.data) intValue];
	}
	else {
		self.loggedIn = NO;	
	}

	return self.loggedIn;
}


- (BOOL)registerNewUser:(NSString*)userName password:(NSString*)pass 
			  firstName:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email {
	NSLog(@"AppModel: New User Registration Requested");
	//createPlayer($strNewUserName, $strPassword, $strFirstName, $strLastName, $strEmail)
	NSArray *arguments = [NSArray arrayWithObjects:userName, pass, firstName, lastName, email, nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithArisJSONServer:jsonServerBaseURL 
																	 andServiceName: @"players" 
																	  andMethodName:@"createPlayer"
																	   andArguments:arguments]; 
	
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest];
	
	if (!jsonResult) {
		NSLog(@"AppModel registerNewUser: No result Data, return");
		return NO;
	}
	
    BOOL success;
	
	int returnCode = jsonResult.returnCode;
	if (returnCode == 0) {
		NSLog(@"AppModel: Result from new user request successfull");
		success = YES;
	}
	else { 
		NSLog(@"AppModel: Result from new user request unsuccessfull");
		success = NO;
	}
	return success;
	
}


- (void)fetchGameList {
	NSLog(@"AppModel: Fetching Game List.");
	
	
	//Call server service
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"games" 
																	 andMethodName:@"getGames" andArguments:nil];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 

	if (!jsonResult) {
		NSLog(@"AppModel fetchGameList: No result Data, return");
		return;
	}
	
	
	//Build the game list
	NSMutableArray *tempGameList = [[NSMutableArray alloc] init];
	NSEnumerator *gamesEnumerator = [((NSArray *)jsonResult.data) objectEnumerator];	
	NSDictionary *gameDictionary;
	while (gameDictionary = [gamesEnumerator nextObject]) {
		//create a new game
		Game *game = [[Game alloc] init];
		game.gameId = [[gameDictionary valueForKey:@"game_id"] intValue];
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
		
		NSLog(@"AppModel: Fetching Locations from Server");	
		
		if (!loggedIn) {
			NSLog(@"AppModel: Player Not logged in yet, skip the location fetch");	
			return;
		}
		
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
	
		//Call server service
		NSArray *arguments = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", self.gameId],
														[NSString stringWithFormat:@"%d",self.playerId], 
														nil];
		JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																		andServiceName:@"locations" 
																		andMethodName:@"getLocationsForPlayer" 
																		andArguments:arguments];
		JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
		
		if (!jsonResult) {
			NSLog(@"AppModel fetchLocationList: No result Data, return");
			return;
		}
		
		//Build the game list
		NSMutableArray *tempLocationsList = [[NSMutableArray alloc] init];
		NSEnumerator *locationsEnumerator = [((NSArray *)jsonResult.data) objectEnumerator];	
		NSDictionary *locationDictionary;
		while (locationDictionary = [locationsEnumerator nextObject]) {
			//create a new location
			Location *location = [[Location alloc] init];
			location.locationId = [[locationDictionary valueForKey:@"location_id"] intValue];
			location.name = [locationDictionary valueForKey:@"name"];
			location.iconURL = [locationDictionary valueForKey:@"icon"];
			location.location = [[CLLocation alloc] initWithLatitude:[[locationDictionary valueForKey:@"latitude"] doubleValue]
														   longitude:[[locationDictionary valueForKey:@"longitude"] doubleValue]];
			location.error = [[locationDictionary valueForKey:@"error"] doubleValue];
			location.objectType = [locationDictionary valueForKey:@"type"];
			location.objectId = [[locationDictionary valueForKey:@"type_id"] intValue];
			location.hidden = [[locationDictionary valueForKey:@"hidden"] boolValue];
			location.forcedDisplay = [[locationDictionary valueForKey:@"force_view"] boolValue];
			location.qty = [[locationDictionary valueForKey:@"item_qty"] intValue];
			
			NSLog(@"Model: Adding Location: %@", location.name);
			[tempLocationsList addObject:location]; 
		}
		
		self.locationList = [NSArray arrayWithArray:tempLocationsList];
		
		//Tell everyone
		NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.gameList forKey:@"gameList"];
		NSLog(@"AppModel: Finished fetching locations from server");
		NSNotification *notification = 
				[NSNotification notificationWithName:@"ReceivedLocationList" object:self userInfo:dictionary];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
		
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
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
													[NSString stringWithFormat:@"%d",self.playerId],
													nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"items" 
																	andMethodName:@"getItemsForPlayer" 
																	andArguments:arguments];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
	
	if (!jsonResult) {
		NSLog(@"AppModel fetchInventory: No result Data, return");
		return;
	}	
	
	//Build the inventory
	NSMutableArray *tempInventory = [[NSMutableArray alloc] init];
	NSEnumerator *inventoryEnumerator = [((NSArray *)jsonResult.data) objectEnumerator];	
	NSDictionary *itemDictionary;
	while (itemDictionary = [inventoryEnumerator nextObject]) {
		Item *item = [[Item alloc] init];
		item.itemId = [[itemDictionary valueForKey:@"item_id"] intValue];
		item.name = [itemDictionary valueForKey:@"name"];
		item.type = [itemDictionary valueForKey:@"type"];
		item.description = [itemDictionary valueForKey:@"description"];
		item.mediaURL = [itemDictionary valueForKey:@"media"];
		item.iconURL = [itemDictionary valueForKey:@"icon"];
		item.dropable = [[itemDictionary valueForKey:@"dropable"] boolValue];
		item.destroyable = [[itemDictionary valueForKey:@"destroyable"] boolValue];
		NSLog(@"Model: Adding Item: %@", item.name);
		[tempInventory addObject:item]; 
	}
	
	self.inventory = [NSArray arrayWithArray:tempInventory];
	
	NSNotification *notification = [NSNotification notificationWithName:@"ReceivedInventory" object:self userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(Item *)fetchItem:(int)itemId{
	NSLog(@"Model: Fetch Requested for Item %d", itemId);
		
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",itemId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"items" 
																	 andMethodName:@"getItem" 
																	  andArguments:arguments];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
	
	
	if (!jsonResult) {
		NSLog(@"AppModel fetchItem: No result Data, return");
		return nil;
	}		
	
	return [self parseItemFromDictionary:(NSDictionary *)jsonResult.data];
}

-(Item *)parseItemFromDictionary: (NSDictionary *)itemDictionary{
	Item *item = [[Item alloc] init];
	item.itemId = [[itemDictionary valueForKey:@"item_id"] intValue];
	item.name = [itemDictionary valueForKey:@"name"];
	item.type = [itemDictionary valueForKey:@"type"];
	item.description = [itemDictionary valueForKey:@"description"];
	item.mediaURL = [itemDictionary valueForKey:@"media"];
	item.iconURL = [itemDictionary valueForKey:@"icon"];
	item.dropable = [[itemDictionary valueForKey:@"dropable"] boolValue];
	item.destroyable = [[itemDictionary valueForKey:@"destroyable"] boolValue];
	NSLog(@"Model: Adding Item: %@", item.name);
	
	return item;	
}


-(Node *)fetchNode:(int)nodeId{
	NSLog(@"Model: Fetch Requested for Node %d", nodeId);
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",nodeId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"nodes" 
																	 andMethodName:@"getNode" 
																	  andArguments:arguments];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
	
	if (!jsonResult) {
		NSLog(@"AppModel fetchNode: No result Data, return");
		return nil;
	}	
	
	
	return [self parseNodeFromDictionary: (NSDictionary *)jsonResult.data];
}

-(Node *)parseNodeFromDictionary: (NSDictionary *)nodeDictionary{
	//Build the node
	Node *node = [[Node alloc] init];
	node.nodeId = [[nodeDictionary valueForKey:@"node_id"] intValue];
	node.name = [nodeDictionary valueForKey:@"title"];
	node.text = [nodeDictionary valueForKey:@"text"];
	node.mediaURL = [nodeDictionary valueForKey:@"mediaURL"];
	
	//Add options here
	int optionNodeId;
	NSString *text;
	NodeOption *option;
	
	if ([nodeDictionary valueForKey:@"opt1_node_id"] != [NSNull null] && [[nodeDictionary valueForKey:@"opt1_node_id"] intValue] > 0) {
		optionNodeId= [[nodeDictionary valueForKey:@"opt1_node_id"] intValue];
		text = [nodeDictionary valueForKey:@"opt1_text"]; 
		option = [[NodeOption alloc] initWithText:text andNodeId: optionNodeId];
		[node addOption:option];
	}
	if ([nodeDictionary valueForKey:@"opt2_node_id"] != [NSNull null] && [[nodeDictionary valueForKey:@"opt2_node_id"] intValue] > 0) {
		optionNodeId = [[nodeDictionary valueForKey:@"opt2_node_id"] intValue];
		text = [nodeDictionary valueForKey:@"opt2_text"]; 
		option = [[NodeOption alloc] initWithText:text andNodeId: optionNodeId];
		[node addOption:option];
	}
	if ([nodeDictionary valueForKey:@"opt3_node_id"] != [NSNull null] && [[nodeDictionary valueForKey:@"opt3_node_id"] intValue] > 0) {
		optionNodeId = [[nodeDictionary valueForKey:@"opt3_node_id"] intValue];
		text = [nodeDictionary valueForKey:@"opt3_text"]; 
		option = [[NodeOption alloc] initWithText:text andNodeId: optionNodeId];
		[node addOption:option];
	}
		
	return node;	
}

-(Npc *)fetchNpc:(int)npcId{
	NSLog(@"Model: Fetch Requested for Npc %d", npcId);
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",npcId],
						  [NSString stringWithFormat:@"%d",self.playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"npcs" 
																	 andMethodName:@"getNpcWithConversationsForPlayer" 
																	  andArguments:arguments];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 

	if (!jsonResult) {
		NSLog(@"AppModel fetchNpc: No result Data, return");
		return nil;
	}	
	
	return [self parseNpcFromDictionary:(NSDictionary *)jsonResult.data];
}

-(Npc *)parseNpcFromDictionary: (NSDictionary *)npcDictionary {
	Npc *npc = [[Npc alloc] init];
	npc.npcId = [[npcDictionary valueForKey:@"npc_id"] intValue];
	npc.name = [npcDictionary valueForKey:@"name"];
	npc.greeting = [npcDictionary valueForKey:@"text"];
	npc.description = [npcDictionary valueForKey:@"description"];
	npc.mediaURL = [npcDictionary valueForKey:@"mediaURL"];
	
	NSArray *conversationOptions = [npcDictionary objectForKey:@"conversationOptions"];
	NSEnumerator *conversationOptionsEnumerator = [conversationOptions objectEnumerator];
	NSDictionary *conversationDictionary;
	while (conversationDictionary = [conversationOptionsEnumerator nextObject]) {	
		//Make the Node Option and add it to the Npc
		int optionNodeId = [[conversationDictionary valueForKey:@"node_id"] intValue];
		NSString *text = [conversationDictionary valueForKey:@"text"]; 
		NodeOption *option = [[NodeOption alloc] initWithText:text andNodeId: optionNodeId];
		[npc addOption:option];
	}
	return npc;	
}

-(NSObject<QRCodeProtocol> *)fetchQRCode:(NSString*)QRcodeId{
	NSLog(@"Model: Fetch Requested for QRCodeId: %@", QRcodeId);
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%@",QRcodeId],
						  [NSString stringWithFormat:@"%d",self.playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"qrcodes" 
																	 andMethodName:@"getQRCodeObjectForPlayer" 
																	  andArguments:arguments];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
	
	
	if (!jsonResult) {
		NSLog(@"AppModel fetchQRCode: No result Data, return");
		return nil;
	}	
	
	
	//Build the object
	NSDictionary *qrCodeDictionary = (NSDictionary *)jsonResult.data;
	NSString *type = [qrCodeDictionary valueForKey:@"type"];
	NSLog(@"QRCode Type: %@",type);

	if ([type isEqualToString:@"Node"]) return [self parseNodeFromDictionary:qrCodeDictionary];
	if ([type isEqualToString:@"Item"]) return [self parseItemFromDictionary:qrCodeDictionary];
	if ([type isEqualToString:@"Npc"]) return [self parseNpcFromDictionary:qrCodeDictionary];
	
	return nil;
}	



-(void)fetchQuestList {
	NSLog(@"Model: Fetch Requested for Quest");
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"quests" 
																	 andMethodName:@"getQuestsForPlayer" 
																	  andArguments:arguments];
	JSONResult *jsonResult = [jsonConnection performSynchronousRequest]; 
	
	if (!jsonResult) {
		NSLog(@"AppModel fetchQuestList: No result Data, return");
		return;
	}		
	
	//Build the questList
	NSDictionary *dataDictionary = (NSDictionary *)jsonResult.data;
	
	//parse out the active quests into quest objects
	NSMutableArray *activeQuestObjects = [[NSMutableArray alloc] init];
	NSArray *activeQuests = [dataDictionary objectForKey:@"active"];
	NSEnumerator *activeQuestsEnumerator = [activeQuests objectEnumerator];
	NSDictionary *activeQuest;
	while (activeQuest = [activeQuestsEnumerator nextObject]) {
		//We have a quest, parse it into a quest abject and add it to the activeQuestObjects array
		Quest *quest = [[Quest alloc] init];
		quest.questId = [[activeQuest objectForKey:@"quest_id"] intValue];
		quest.name = [activeQuest objectForKey:@"name"];
		quest.description = [activeQuest objectForKey:@"description"];
		quest.mediaURL = [activeQuest objectForKey:@"mediaURL"];
		[activeQuestObjects addObject:quest];
 	}
	
		
	//parse out the completed quests into quest objects	
	NSMutableArray *completedQuestObjects = [[NSMutableArray alloc] init];
	NSArray *completedQuests = [dataDictionary objectForKey:@"completed"];
	NSEnumerator *completedQuestsEnumerator = [completedQuests objectEnumerator];
	NSDictionary *completedQuest;
	while (completedQuest = [completedQuestsEnumerator nextObject]) {
		//We have a quest, parse it into a quest abject and add it to the completedQuestObjects array
		Quest *quest = [[Quest alloc] init];
		quest.questId = [[completedQuest objectForKey:@"quest_id"] intValue];
		quest.name = [completedQuest objectForKey:@"name"];
		quest.description = [completedQuest objectForKey:@"text_when_complete"];
		quest.mediaURL = [completedQuest objectForKey:@"mediaURL"];
		[completedQuestObjects addObject:quest];
	}
	
	//Package the two object arrays in a Dictionary
	NSMutableDictionary *tmpQuestList = [[NSMutableDictionary alloc] init];
	[tmpQuestList setObject:activeQuestObjects forKey:@"active"];
	[tmpQuestList setObject:completedQuestObjects forKey:@"completed"];

	//Save it as the model's quest list
	questList = tmpQuestList;
	
	//Sound the alarm
	NSNotification *notification = [NSNotification notificationWithName:@"ReceivedQuestList" object:self userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)updateServerNodeViewed: (int)nodeId {
	NSLog(@"Model: Node %d Viewed, update server", nodeId);
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",nodeId],
						  [NSString stringWithFormat:@"%d",playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"players" 
																	 andMethodName:@"nodeViewed" 
																	  andArguments:arguments];
	[jsonConnection performSynchronousRequest]; 
}

- (void)updateServerItemViewed: (int)itemId {
	NSLog(@"Model: Item %d Viewed, update server", itemId);
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",itemId],
						  [NSString stringWithFormat:@"%d",playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"players" 
																	 andMethodName:@"itemViewed" 
																	  andArguments:arguments];
	[jsonConnection performSynchronousRequest]; 
}

- (void)updateServerGameSelected{
	NSLog(@"Model: Game %d Selected, update server", gameId);
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: 
						  [NSString stringWithFormat:@"%d",self.playerId],
						  [NSString stringWithFormat:@"%d",playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"players" 
																	 andMethodName:@"updatePlayerLastGame" 
																	  andArguments:arguments];
	[jsonConnection performSynchronousRequest]; 
}


- (void)resetPlayerEvents {
	NSLog(@"Model: Clearing Player Events");
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"players" 
																	 andMethodName:@"resetEvents" 
																	  andArguments:arguments];
	[jsonConnection performSynchronousRequest]; 
}

- (void)resetPlayerItems {
	NSLog(@"Model: Clearing Player Items");
	
	//Call server service
	NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.gameId],
						  [NSString stringWithFormat:@"%d",playerId],
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																	andServiceName:@"players" 
																	 andMethodName:@"resetItems" 
																	  andArguments:arguments];
	[jsonConnection performSynchronousRequest]; 
}

- (void)createItemForImage: (UIImage *)image{
	NSLog(@"Model: creating a new Item for an image");
	
	//Upload the file to get it's name
	
	//Create the media record, add the item to the game and add this item to the players inventory

}


- (void)updateServerLocationAndfetchNearbyLocationList {
	@synchronized (nearbyLock) {
		NSLog(@"Model: updating player position on server and determining nearby Locations");
		
		if (!loggedIn) {
			NSLog(@"Model: Player Not logged in yet, skip the location update");	
			return;
		}
		
		//init a fresh nearby location list array
		if(nearbyLocationsList != nil) {
			[nearbyLocationsList release];
		}
		nearbyLocationsList = [NSMutableArray array];
		[nearbyLocationsList retain];
	
		//Update the server with the new Player Location
		NSArray *arguments = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",self.playerId],
							  [NSString stringWithFormat:@"%f",playerLocation.coordinate.latitude],
							  [NSString stringWithFormat:@"%f",playerLocation.coordinate.longitude],
							  nil];
		JSONConnection *jsonConnection = [[JSONConnection alloc]initWithArisJSONServer:self.jsonServerBaseURL 
																		andServiceName:@"players" 
																		andMethodName:@"updatePlayerLocation" 
																		andArguments:arguments];
		[jsonConnection performSynchronousRequest]; 
		
		
		//Rebuild nearbyLocationList
		//We could just do this in the getter
		NSEnumerator *locationsListEnumerator = [locationList objectEnumerator];
		Location *location;
		while (location = [locationsListEnumerator nextObject]) {
			//check if the location is close to the player
			if ([playerLocation getDistanceFrom:location.location] < location.error)
				[nearbyLocationsList addObject:location];
		}

		//Tell the rest of the app that the nearbyLocationList is fresh
		NSNotification *nearbyLocationListNotification = 
					[NSNotification notificationWithName:@"ReceivedNearbyLocationList" object:nearbyLocationsList];
		[[NSNotificationCenter defaultCenter] postNotification:nearbyLocationListNotification];
	}
}

- (void)createPlayer{
	NSLog(@"Model: Creating Player");
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
    [super dealloc];
}

@end

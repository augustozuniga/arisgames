//
//  AppModel.h
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "Game.h"
#import "Item.h"

extern NSDictionary *InventoryElements;

@interface AppModel : NSObject {
	NSUserDefaults *defaults;
	NSString *serverName;
	NSString *baseAppURL;
	NSString *jsonServerBaseURL;
	BOOL loggedIn;
	int playerId;
	NSString *username;
	NSString *password;
	UIViewController *currentModule;
	NSString *site;
	int gameId;
	NSMutableArray *gameList;
	NSMutableArray *locationList;
	NSMutableArray *playerList;
	NSMutableArray *nearbyLocationsList;
	CLLocation *playerLocation;
	NSMutableArray *inventory;
	UIAlertView *networkAlert;
}

@property(copy) NSString *serverName;
@property(copy, readwrite) NSString *baseAppURL;
@property(copy, readwrite) NSString *jsonServerBaseURL;
@property(readwrite) BOOL loggedIn;
@property(copy, readwrite) NSString *username;
@property(copy, readwrite) NSString *password;
@property(readwrite) int playerId;
@property(copy, readwrite) UIViewController *currentModule;
@property(copy, readwrite) NSString *site;
@property(readwrite) int gameId;
@property(copy, readwrite) NSMutableArray *gameList;	
@property(copy, readwrite) NSMutableArray *locationList;
@property(copy, readwrite) NSMutableArray *playerList;
@property(copy, readwrite) NSMutableArray *nearbyLocationsList;	
@property(copy, readwrite) CLLocation *playerLocation;	
@property(copy, readwrite) NSMutableArray *inventory;
@property(retain) UIAlertView *networkAlert;


-(id)init;
-(void)loadUserDefaults;
-(void)clearUserDefaults;
-(void)saveUserDefaults;
-(void)initUserDefaults;
-(BOOL)login;
-(void)fetchGameList;
-(void)fetchLocationList;
-(void)fetchInventory;
-(Item *)fetchItem:(int)itemId;
-(void)updateServerLocationAndfetchNearbyLocationList;
-(NSMutableURLRequest *) getURLForModule:(NSString *)moduleName;
-(NSString *)getURLStringForModule:(NSString *)moduleName;
-(NSString *) getURLString:(NSString *)relativeURL;
-(NSMutableURLRequest *)getURL:(NSString *)relativeURL;
-(NSMutableURLRequest *)getEngineURL:(NSString *)relativeURL;
-(NSString *) getEngineURLString:(NSString *)relativeURL;
-(NSData *) fetchURLData: (NSURLRequest *)request;


@end

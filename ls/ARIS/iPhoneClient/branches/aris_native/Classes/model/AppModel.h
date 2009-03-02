//
//  AppModel.h
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h";

@interface AppModel : NSObject {
	NSString *baseAppURL;
	NSString *username;
	NSString *password;
	NSString *currentModule;
	NSString *site;
	NSMutableArray *gameList;
	NSMutableArray *locationList;
	NSString *lastLatitude;
	NSString *lastLongitude;
}

@property(copy, readwrite) NSString *baseAppURL;
@property(copy, readwrite) NSString *username;
@property(copy, readwrite) NSString *password;
@property(copy, readwrite) NSString *currentModule;
@property(copy, readwrite) NSString *site;
@property(copy, readwrite) NSMutableArray *gameList;	
@property(copy, readwrite) NSMutableArray *locationList;	
@property(copy, readwrite) NSString *lastLatitude;
@property(copy, readwrite) NSString *lastLongitude;

-(BOOL)login;
-(void)fetchGameList;
-(void)fetchLocationList;
-(NSURLRequest *) getURLForModule:(NSString *)moduleName;

@end

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
}

@property(copy, readwrite) NSString *baseAppURL;
@property(copy, readwrite) NSString *username;
@property(copy, readwrite) NSString *password;
@property(copy, readwrite) NSString *currentModule;
@property(copy, readwrite) NSString *site;
@property(copy, readwrite) NSMutableArray *gameList;

-(BOOL)login;
-(void)fetchGameList;
-(NSURLRequest *) getURLForModule:(NSString *)moduleName;

@end

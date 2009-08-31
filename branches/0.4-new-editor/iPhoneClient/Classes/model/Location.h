//
//  Location.h
//  ARIS
//
//  Created by David Gagnon on 2/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Location : NSObject {
	int locationId;
	NSString *iconURL;
	NSString *name;
	double latitude;
	double longitude;
	double error;
	NSString *objectType;
	int objectId;
	bool hidden;
	bool forceView;
	int qty;
	
}

@property(readwrite, assign) int locationId;
@property(copy, readwrite) NSString *name;
@property(copy, readwrite) NSString *iconURL;
@property(readwrite) double latitude;
@property(readwrite) double longitude;
@property(readwrite) double error;
@property(copy, readwrite) NSString *objectType;
@property(readwrite) int objectId;
@property(readwrite) bool hidden;
@property(readwrite) bool forceView;
@property(readwrite) int qty;

@end

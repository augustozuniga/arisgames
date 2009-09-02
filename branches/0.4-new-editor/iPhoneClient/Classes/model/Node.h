//
//  Node.h
//  ARIS
//
//  Created by David J Gagnon on 8/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearbyObjectProtocol.h"
#import "QRCodeProtocol.h"

@interface Node : NSObject <NearbyObjectProtocol,QRCodeProtocol> {
	nearbyObjectKind kind;
	int nodeId;
	NSString *name;
	NSString *text;
	NSString *mediaURL;
	NSMutableArray *options;
	NSInteger numberOfOptions;

	BOOL forcedDisplay; //We only need this for the proto, might be good to define a new one

}


@property(readwrite, assign) nearbyObjectKind kind;
- (nearbyObjectKind) kind;
@property(readwrite, assign) int nodeId;
@property(copy, readwrite) NSString *name;
@property(copy, readwrite) NSString *text;
@property(copy, readwrite) NSString *mediaURL;
@property(readwrite, assign) NSMutableArray *options;
@property(readwrite) NSInteger numberOfOptions;
- (NSInteger) numberOfOptions;
@property(readwrite, assign) BOOL forcedDisplay; //see note above

- (void) display;


@end


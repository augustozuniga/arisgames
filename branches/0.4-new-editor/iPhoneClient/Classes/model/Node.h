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
#import "NodeOption.h"

@interface Node : NSObject <NearbyObjectProtocol,QRCodeProtocol> {
	nearbyObjectKind	kind;
	int					nodeId;
	NSString			*name;
	NSString			*text;
	int					mediaId;
	NSMutableArray		*options;
	NSInteger			numberOfOptions;

	BOOL forcedDisplay; //We only need this for the proto, might be good to define a new one
}

@property(readwrite, assign) nearbyObjectKind kind;
- (nearbyObjectKind) kind;
@property(readwrite, assign) int nodeId;
@property(copy, readwrite) NSString *name;
@property(copy, readwrite) NSString *text;
@property(readwrite, assign) int mediaId;
@property(readonly) NSMutableArray *options;
@property(readonly) NSInteger numberOfOptions;
- (NSInteger) numberOfOptions;
- (void) addOption: (NodeOption *)newOption;
- (void) display;

@property(readwrite, assign) BOOL forcedDisplay; //see note above


@end


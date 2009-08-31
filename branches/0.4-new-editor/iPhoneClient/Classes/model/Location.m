//
//  Location.m
//  ARIS
//
//  Created by David Gagnon on 2/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location

@synthesize locationId;
@synthesize name;
@synthesize iconURL;
@synthesize location;
@synthesize error;
@synthesize objectType;
@synthesize objectId;
@synthesize hidden;
@synthesize forcedDisplay;
@synthesize qty;

-(nearbyObjectKind) kind {
	if ([objectType isEqualToString:@"Node"]) return NearbyObjectNode;
	if ([objectType isEqualToString:@"Npc"]) return NearbyObjectNPC;
	if ([objectType isEqualToString:@"Item"]) return NearbyObjectItem;
}

- (void)dealloc {
	[name release];
    [super dealloc];
}

@end

//
//  Location.m
//  ARIS
//
//  Created by David Gagnon on 2/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "ARISAppDelegate.h"
#import "AppModel.h"
#import "Item.h"
#import "Node.h"


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
	if ([self.objectType isEqualToString:@"Node"]) return NearbyObjectNode;
	if ([self.objectType isEqualToString:@"Npc"]) return NearbyObjectNPC;
	if ([self.objectType isEqualToString:@"Item"]) return NearbyObjectItem;
}

- (void)display {
	ARISAppDelegate *appDelegate = (ARISAppDelegate *)[[UIApplication sharedApplication] delegate];
	AppModel *model = [appDelegate appModel];
	
	if (self.kind == NearbyObjectItem) {
		Item *item = [model fetchItem:objectId]; 
		[item display];	
	}
	
	if (self.kind == NearbyObjectNode) {
		Node *node = [model fetchNode:objectId]; 
		[node display];	
	}
	
}

- (void)dealloc {
	[name release];
    [super dealloc];
}

@end

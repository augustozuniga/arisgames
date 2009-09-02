//
//  NPC.m
//  ARIS
//
//  Created by David J Gagnon on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Npc.h"
#import "ARISAppDelegate.h"
#import "AppModel.h"
#import "NpcViewController.h"

@implementation Npc
@synthesize npcId;
@synthesize name;
@synthesize greeting;
@synthesize description;
@synthesize mediaURL;
@synthesize kind;
@synthesize forcedDisplay;
@synthesize numberOfOptions;
@synthesize options;

-(nearbyObjectKind) kind {
	return NearbyObjectNPC;
}

- (Npc *)init {
	self = [super init];
    if (self) {
		options = [[NSMutableArray alloc] init];
    }
	
    return self;	
}

- (NSInteger) numberOfOptions {
	return [options count];
}

- (void) addOption:(NodeOption *)newOption{
	[options addObject:newOption];
}

- (void) display{
	NSLog(@"Npc: Display Self Requested");
	
	//Create a reference to the delegate using the application singleton.
	ARISAppDelegate *appDelegate = (ARISAppDelegate *) [[UIApplication sharedApplication] delegate];
	AppModel *appModel = appDelegate.appModel;
	
	NpcViewController *npcViewController = [[NpcViewController alloc] initWithNibName:@"Npc" bundle: [NSBundle mainBundle]];
	npcViewController.npc = self; //currentNode;
	npcViewController.appModel = appModel;
	
	[appDelegate displayNearbyObjectView:npcViewController];
	
}


@end

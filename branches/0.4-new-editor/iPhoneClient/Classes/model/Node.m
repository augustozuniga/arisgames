//
//  Node.m
//  ARIS
//
//  Created by David J Gagnon on 8/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Node.h"
#import "ARISAppDelegate.h"
#import "AppModel.h"
#import "NodeViewController.h"

@implementation Node

@synthesize nodeId;
@synthesize name;
@synthesize text;
@synthesize mediaId;
@synthesize kind;
@synthesize forcedDisplay;
@synthesize numberOfOptions;
@synthesize options;

-(nearbyObjectKind) kind {
	return NearbyObjectNode;
}

- (Node *)init {
	self = [super init];
    if (self) {
		kind = NearbyObjectNode;
		options = [[NSMutableArray alloc] init];
    }
	
    return self;	
}


- (void) display{
	NSLog(@"Node: Display Self Requested");
	
	//Create a reference to the delegate using the application singleton.
	ARISAppDelegate *appDelegate = (ARISAppDelegate *) [[UIApplication sharedApplication] delegate];
	AppModel *appModel = appDelegate.appModel;

	NodeViewController *nodeViewController = [[NodeViewController alloc] initWithNibName:@"Node" bundle: [NSBundle mainBundle]];
	nodeViewController.node = self; //currentNode;
	nodeViewController.appModel = appModel;
	
	[appDelegate displayNearbyObjectView:nodeViewController];
}

- (NSInteger) numberOfOptions {
	return [options count];
}

- (void) addOption:(NodeOption *)newOption{
	[options addObject:newOption];
}





@end

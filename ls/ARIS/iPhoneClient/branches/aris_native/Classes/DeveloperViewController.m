//
//  DeveloperViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/16/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "DeveloperViewController.h"


@implementation DeveloperViewController

@synthesize moduleName;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	moduleName = @"RESTDeveloper";
	
	NSLog(@"Developer loaded");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark custom methods and logic

-(void) setModel:(AppModel *)model {
	NSLog(@"model set for DEV");
}

- (void)changeGameAction {
	NSLog(@"GAME CHANGE CALLED");
}

- (void)dealloc {
	[moduleName release];
    [super dealloc];
}


@end

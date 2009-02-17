//
//  ToolbarViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/13/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "ToolbarViewController.h"


@implementation ToolbarViewController

@synthesize titleLabel;

-(void) setToolbarTitle:(NSString *)title {
	//NSLog(@"setToolbarTitle");
	titleLabel.text = title;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"TOOLBAR VIEW LOADED");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[titleLabel release];
    [super dealloc];
}


@end

//
//  Option.m
//  ARIS
//
//  Created by Kevin Harris on 5/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NodeOption.h"


@implementation NodeOption
@synthesize text, nodeId;


-(NodeOption*) initWithText:(NSString *)optionText andNodeId: (int)optionNodeId{
	self.text = optionText;
	self.nodeId = optionNodeId;
	return self;
}


@end

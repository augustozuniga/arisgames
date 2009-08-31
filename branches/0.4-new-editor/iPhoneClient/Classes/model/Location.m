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
@synthesize latitude;
@synthesize longitude;
@synthesize error;
@synthesize objectType;
@synthesize objectId;
@synthesize hidden;
@synthesize forceView;
@synthesize qty;


- (void)dealloc {
	[name release];
    [super dealloc];
}

@end

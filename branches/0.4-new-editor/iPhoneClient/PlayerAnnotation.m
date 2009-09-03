//
//  PlayerAnnotation.m
//  ARIS
//
//  Created by Brian Deith on 7/27/09.
//  Copyright 2009 Brian Deith. All rights reserved.
//

#import "PlayerAnnotation.h"


@implementation PlayerAnnotation

@synthesize coordinate, title, subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	NSLog(@"Got a player marker");
	if (self == [super init]) {
		coordinate=c;
	}
	return self;
}

@end

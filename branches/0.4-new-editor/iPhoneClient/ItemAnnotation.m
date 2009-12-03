//
//  ItemAnnotation.m
//  ARIS
//
//  Created by Brian Deith on 7/21/09.
//  Copyright 2009 Brian Deith. All rights reserved.
//

#import "ItemAnnotation.h"


@implementation ItemAnnotation

@synthesize coordinate, title, subtitle, iconMediaId;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	if (self == [super init]) {
		coordinate=c;
	}
	NSLog(@"Item annotation created");
	return self;
}


@end

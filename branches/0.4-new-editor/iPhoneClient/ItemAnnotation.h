//
//  Annotation.h
//  ARIS
//
//  Created by Brian Deith on 7/21/09.
//  Copyright 2009 Brian Deith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Media.h"

@interface ItemAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	int iconMediaId;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (readwrite, copy) NSString *title;
@property (readwrite, copy) NSString *subtitle;
@property(readwrite, assign) int iconMediaId;



- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end

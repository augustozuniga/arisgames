//
//  Annotation.h
//  ARIS
//
//  Created by Brian Deith on 7/21/09.
//  Copyright 2009 Brian Deith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ItemAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	NSString *iconURL;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (readwrite, copy) NSString *title;
@property (readwrite, copy) NSString *subtitle;
@property (readwrite, copy) NSString *iconURL;



- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end

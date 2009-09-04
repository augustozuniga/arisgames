//
//  GPSViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "Location.h"
#import <MapKit/MapKit.h>
#import "PlayerAnnotation.h"
#import "ItemAnnotation.h"



@interface GPSViewController : UIViewController <MKMapViewDelegate> {
	AppModel *appModel;
	MKMapView *mapView;
	PlayerAnnotation *playerMarker;
	BOOL autoCenter;
}

-(void) refresh;
-(void) zoomAndCenterMap;
-(void) refreshPlayerMarker;


@property (nonatomic, retain) MKMapView *mapView;
@property BOOL autoCenter;

@end

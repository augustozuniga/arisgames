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
	NSString *moduleName;
	AppModel *appModel;
	MKMapView *mapView;

//	RMMapView *mapView;
//	RMMarker *playerMarker;
//	RMMarkerManager *markerManager;
	PlayerAnnotation *playerMarker;
	BOOL autoCenter;
	//CLLocationManager *locationManager;
}

-(void) setModel:(AppModel *)model;
-(void) refreshMap;
-(void) zoomAndCenterMap;
-(void) refreshPlayerMarker;


@property(copy, readwrite) NSString *moduleName;
@property (nonatomic, retain) MKMapView *mapView;
@property BOOL autoCenter;

@end

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
	IBOutlet UIBarButtonItem *mapTypeButton;
	IBOutlet UIBarButtonItem *playerTrackingButton;
	IBOutlet UIBarButtonItem *gpsAccuracyIndicator;
}

-(void) refresh;
-(void) zoomAndCenterMap;
-(void) refreshPlayerMarker;


@property (nonatomic, retain) MKMapView *mapView;
@property BOOL autoCenter;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mapTypeButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *playerTrackingButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *gpsAccuracyIndicator;

@end

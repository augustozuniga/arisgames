//
//  GPSViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";
#import "RMMapView.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"


@interface GPSViewController : UIViewController {
	NSString *moduleName;
	AppModel *appModel;
	RMMapView *mapView;
	IBOutlet UIWebView *webView;
	RMMarker *playerMarker;
	RMMarkerManager *markerManager;
}

-(void) setModel:(AppModel *)model;
-(void) drawMap;


@property(copy, readwrite) NSString *moduleName;
@property (nonatomic, retain) RMMapView *mapView;


@end

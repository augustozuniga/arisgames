//
//  CameraViewController.h
//  ARIS
//
//  Created by David Gagnon on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";


@interface CameraViewController : UIViewController {
	NSString *moduleName;
	AppModel *appModel;
	
	IBOutlet UIButton *button;
    IBOutlet UIImageView *image;
    UIImagePickerController *imagePickerController;
}


- (void) setModel:(AppModel *)model;
- (IBAction)grabImage;

@property(copy, readwrite) NSString *moduleName;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;


@end

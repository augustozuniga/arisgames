//
//  CameraViewController.m
//  ARIS
//
//  Created by David Gagnon on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"


@implementation CameraViewController

@synthesize moduleName;
@synthesize imagePickerController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	moduleName = @"RESTCamera";
		
	self.imagePickerController = [[UIImagePickerController alloc] init];
	self.imagePickerController.allowsImageEditing = YES;
	self.imagePickerController.delegate = self;
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	//self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	NSLog(@"IMView Loaded");
}

-(void) setModel:(AppModel *)model {
	if(appModel != model) {
		[appModel release];
		appModel = model;
		[appModel retain];
	}	
	NSLog(@"model set for Camera");
}

- (IBAction)grabImage {
	NSLog(@"Take Photo Button Pressed");
	[self presentModalViewController:self.imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	image.image = img;
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end

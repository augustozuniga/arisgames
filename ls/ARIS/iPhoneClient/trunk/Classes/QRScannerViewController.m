//
//  CameraViewController.m
//  ARIS
//
//  Created by David Gagnon on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QRScannerViewController.h"


@implementation QRScannerViewController

@synthesize moduleName;
@synthesize imagePickerController;
@synthesize scanButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	moduleName = @"RESTQRScanner";
	
	
	self.imagePickerController = [[UIImagePickerController alloc] init];
	self.imagePickerController.allowsImageEditing = YES;
	self.imagePickerController.delegate = self;
	
	NSLog(@"QRScannerViewController Loaded");
}

-(void) setModel:(AppModel *)model {
	if(appModel != model) {
		[appModel release];
		appModel = model;
		[appModel retain];
	}	
	NSLog(@"model set for QRScannerViewController");
}

- (IBAction)scanButtonTouchAction: (id) sender{
	NSLog(@"Scan Button Pressed");
	
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:self.imagePickerController animated:YES];
	 
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	//img is now available to us
	
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

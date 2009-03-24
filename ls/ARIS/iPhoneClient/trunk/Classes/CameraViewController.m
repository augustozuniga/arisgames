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

- (IBAction)cameraButtonTouchAction {
	NSLog(@"Camera Button Pressed");
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:self.imagePickerController animated:YES];
}

- (IBAction)libraryButtonTouchAction {
	NSLog(@"Library Button Pressed");
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:self.imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	image.image = img;
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)uploadButtonTouchAction {
	
	// setting up the URL to post to
	NSString *urlString= [NSString stringWithFormat: @"%@%@", [appModel getURLStringForModule:moduleName],"&event=upload"];
	NSLog([NSString stringWithFormat: @"Preparing to send file from camera to: %@", urlString] );
	
	/*
	
	//turning the image in the UIView into a NSData JPEG object at 90% quality
	NSData *imageData = UIImageJPEGRepresentation(image.image, .9);

		  
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	//Add headers
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//body
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// post it
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog([NSString stringWithFormat: @"Camera file posted. Result from Server: %@", returnString]);
	 */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end

//
//  ItemDetailsViewController.m
//  ARIS
//
//  Created by David Gagnon on 4/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ItemDetailsViewController.h"


@implementation ItemDetailsViewController

@synthesize appModel;
@synthesize item;
@synthesize imageView;
@synthesize descriptionView;
@synthesize dropButton;
@synthesize deleteButton;
@synthesize backButton;


-(void) setModel:(AppModel *)model{
	if(appModel != model) {
		[appModel release];
		appModel = model;
		[appModel retain];
	}
	NSLog(@"model set for ItemDetailsViewController");
}

-(void) setItem:(Item *)newItem{
	if(item != newItem) {
		[item release];
		item = newItem;
		[item retain];
	}
	
	NSLog(@"item set for ItemDetailsViewController");
}


- (IBAction)dropButtonTouchAction: (id) sender{
	//Fire off a request to the REST Module and display an alert when it is successfull
	NSString *baseURL = [appModel getURLStringForModule:@"RESTInventory"];
	NSString *URLparams = [ NSString stringWithFormat:@"&event=dropItemHere&item_id=%d", self.item.itemId];
	NSString *fullURL = [ NSString stringWithFormat:@"%@%@", baseURL, URLparams];
	
	NSLog([NSString stringWithFormat:@"Dropping Item Here using REST Call: %@", fullURL ]);
	
	NSString *result = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fullURL]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success" message: result delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	[alert show];
	[result release];
	[alert release];
	
	//Refresh the inventory - CRASHES?
	//[appModel fetchInventory];
	
	//Dismiss Item Details View
	[self dismissModalViewControllerAnimated:NO];
	
}
- (IBAction)deleteButtonTouchAction: (id) sender{
	//Fire off a request to the REST Module and display an alert when it is successfull
	NSString *baseURL = [appModel getURLStringForModule:@"RESTInventory"];
	NSString *URLparams = [ NSString stringWithFormat:@"&event=destroyPlayerItem&item_id=%d", self.item.itemId];
	NSString *fullURL = [ NSString stringWithFormat:@"%@%@", baseURL, URLparams];
	
	NSLog([NSString stringWithFormat:@"Deleting all Items for this Player on server: %@", fullURL ]);
	
	NSString *result = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fullURL]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success" message: result delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	[alert show];
	[result release];
	[alert release];
	
	//Refresh the inventory - CRASHES?
	//[appModel fetchInventory];
	
	//Dismiss Item Details View
	[self dismissModalViewControllerAnimated:NO];
	
}
- (IBAction)backButtonTouchAction: (id) sender{
	NSLog(@"Dismiss Item Details View");
	[self dismissModalViewControllerAnimated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	descriptionView.text = item.description;
	
	//if ([item.type isEqualToString: @"Image"]) {
		//Load Image
		
		NSString* imageURL = [item.mediaURL stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
		UIImage* image = [[UIImage alloc] initWithData:imageData];
		[imageView setImage:image];
		[imageData release];
		[image release];
		 
	//}
	
	[super viewDidLoad];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end

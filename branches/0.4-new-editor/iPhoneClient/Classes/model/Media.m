//
//  Media.m
//  ARIS
//
//  Created by Kevin Harris on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Media.h"
#import "ARISAppDelegate.h"

@implementation Media
@synthesize uid, url, type, imageView;

- (id) initWithId:(NSInteger)anId andUrlString:(NSString *)aUrl ofType:(NSString *)aType {
	assert(anId > 0 && @"Non-natural ID.");
	assert(aUrl && [aUrl length] > 0 && @"Empty url string.");
	assert(aType && [aType length] > 0 && "@Empty type.");
	
	if (self = [super init]) {
		uid = anId;
		url = [aUrl retain];
		type = [aType retain];
	}
	
	return self;
}



- (void) performAsynchronousImageLoadWithTargetImageView: (UIImageView*)anImageView{
		
	NSLog(@"Media: URL for async load is : %@", url);
	
	//Make the UIImage this media's image
	imageView = anImageView;
	
	//Convert into a NSURLRequest
	NSURL *requestURL = [[NSURL alloc]initWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestURL
											 cachePolicy:NSURLRequestReturnCacheDataElseLoad
										 timeoutInterval:30];
	
	//set up indicators
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	
	//do it
	NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	asyncData = [NSMutableData dataWithCapacity:10000];
	[asyncData retain];
	[urlConnection start];
	
	NSLog(@"Media: Begining Async request");
	
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Media: Recieved Async Data");
	[asyncData appendData:data];
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"Media: Finished Loading Data");
	
	//end the UI indicator
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if ([[imageView subviews] count]>0) {
        [[[imageView subviews] objectAtIndex:0] removeFromSuperview];
    }
	
    UIImageView* imageSubView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:asyncData]] autorelease];
	
    //imageSubView.contentMode = UIViewContentModeScaleAspectFit;
    //imageSubView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	
    [imageView addSubview:imageSubView];
    imageSubView.frame = imageView.bounds;

	[imageView setNeedsLayout];
	[imageSubView setNeedsLayout];
	
	[asyncData release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Media: Error communicating with server. %d", error.code);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showNetworkAlert];	
	

	
	[asyncData release];
}







@end

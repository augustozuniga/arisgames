//
//  JSONConnection.m
//  ARIS
//
//  Created by David J Gagnon on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JSONConnection.h"
#import "AppModel.h"
#import "ARISAppDelegate.h"


@implementation JSONConnection

@synthesize jsonServerBaseURL;
@synthesize serviceName;
@synthesize methodName;
@synthesize arguments;

- (JSONConnection*)initWithArisJSONServer:(NSString *)server
			   andServiceName:(NSString *)service 
				andMethodName:(NSString *)method
				 andArguments:(NSArray *)args{
	
	self.jsonServerBaseURL = server;
	self.serviceName = service;
	self.methodName = method;	
	self.arguments = args;	

	return self;
}

- (JSONResult*) performSynchronousRequest{
	//Build the base URL string
	NSMutableString *requestString = [[NSMutableString alloc] initWithFormat:@"%@.%@.%@", 
							   self.jsonServerBaseURL, self.serviceName, self.methodName];
	
	//Add the Arguments
	NSEnumerator *argumentsEnumerator = [self.arguments objectEnumerator];
	NSString *argument;
	while (argument = [argumentsEnumerator nextObject]) {
		[requestString appendString:@"/"];
		[requestString appendString:argument];
	}

	NSLog(@"JSONConnection: JSON URL for request is : %@", requestString);
	
	//Convert into a NSURLRequest
	NSURL *requestURL = [[NSURL alloc]initWithString:requestString];
	NSURLRequest *requestURLRequest = [NSURLRequest requestWithURL:requestURL
													   cachePolicy:NSURLRequestReturnCacheDataElseLoad
												   timeoutInterval:30];
	
	// Make synchronous request
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showWaitingIndicator: @"Loading"];
	
	NSURLResponse *response;
	NSError *error;
	NSData *resultData = [NSURLConnection sendSynchronousRequest:requestURLRequest
											   returningResponse:&response
														   error:&error];	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] removeWaitingIndicator];

	if (error != NULL) {
		NSLog(@"JSONConnection: Error communicating with server. %d", error.code);
		[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showNetworkAlert];	
	}	
	
	NSString *jsonString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
	
	//Get the JSONResult here
	JSONResult *jsonResult = [[JSONResult alloc] initWithJSONString:jsonString];
	
	return jsonResult;
}


@end

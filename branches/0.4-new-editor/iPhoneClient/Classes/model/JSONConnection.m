//
//  JSONConnection.m
//  ARIS
//
//  Created by David J Gagnon on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JSONConnection.h"


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
	NSURLResponse *response;
	NSError *error;
	NSData *resultData = [NSURLConnection sendSynchronousRequest:requestURLRequest
											   returningResponse:&response
														   error:&error];	
	NSString *jsonString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
	
	//Get the JSONResult here
	JSONResult *jsonResult = [[JSONResult alloc] initWithJSONString:jsonString];
	return jsonResult;
}


@end

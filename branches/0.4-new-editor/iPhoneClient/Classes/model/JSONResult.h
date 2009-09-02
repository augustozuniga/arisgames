//
//  JSONResult.h
//  ARIS
//
//  Created by David J Gagnon on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSONResult : NSObject {
	int returnCode;
	NSString *returnCodeDescription;
	NSObject *data;
}

@property(readwrite) int returnCode;
@property(copy, readwrite) NSString *returnCodeDescription;
@property(copy, readwrite) NSObject *data;


- (JSONResult*)initWithJSONString:(NSString *)JSONString;
- (NSObject*) parseJSONData:(NSObject *)dictionary;



@end



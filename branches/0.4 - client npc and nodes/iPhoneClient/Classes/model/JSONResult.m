//
//  JSONResult.m
//  ARIS
//
//  Created by David J Gagnon on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JSONResult.h"
#import "JSON.h"

@implementation JSONResult

@synthesize returnCode;
@synthesize returnCodeDescription;
@synthesize data;



- (JSONResult*)initWithJSONString:(NSString *)JSONString{

	// Parse JSON into a resultObject
	SBJSON *json = [[SBJSON new] autorelease];
	NSError *jsonError;
	NSDictionary *resultDictionary = [json objectWithString:JSONString error:&jsonError];

	self.returnCode = [[resultDictionary objectForKey:@"returnCode"]intValue];
	self.returnCodeDescription = [resultDictionary objectForKey:@"returnCodeDescription"];

	NSObject *dataObject = [resultDictionary objectForKey:@"data"];

	NSLog(@"PARSER data: %@", dataObject);
	
	//Here we need to determine if the return data is a bool, int or recordset
	if ([dataObject isKindOfClass:[NSDictionary class]]) {
		NSDictionary *dataDictionary = ((NSDictionary*) dataObject);
		NSArray *columnsArray = [dataDictionary objectForKey:@"columns"];
		NSArray *rowsArray = [dataDictionary objectForKey:@"rows"];
		NSEnumerator *rowsEnumerator = [rowsArray objectEnumerator];
		NSMutableArray *dictionaryArray = [[NSMutableArray alloc] init];

		//add each row as a dictionary to the dictionaryArray 
		NSArray *rowArray;
		while (rowArray = [rowsEnumerator nextObject]) {		
			NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
			for (int i = 0; i < [rowArray count]; i++) {
				NSString *value = [rowArray objectAtIndex:i];
				NSString *key = [columnsArray objectAtIndex:i];
				[tempDictionary setObject:value forKey:key];
			} 
			[dictionaryArray addObject: tempDictionary];
			[tempDictionary release];		
		}
		self.data = dictionaryArray;
	}
	else self.data = dataObject;
		
	return self;
	
}







@end

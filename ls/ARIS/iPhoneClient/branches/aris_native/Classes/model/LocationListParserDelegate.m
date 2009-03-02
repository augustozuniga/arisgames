//
//  LocationListParserDelegate.m
//  ARIS
//
//  Created by David Gagnon on 2/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationListParserDelegate.h"
#import "Location.h";

@implementation LocationListParserDelegate

- (LocationListParserDelegate*)initWithLocationList:(NSMutableArray *)modelLocationList {
	self = [super init];
    if ( self ) {
		locationList = modelLocationList;
		[locationList retain];
    }
	
    return self;
	
	
}


#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict {
	if(qName) {
		elementName = qName;
	}
	
	if ([elementName isEqualToString:@"location"]) {
		//ok, new game
		NSLog(@"NEW Location!!");
		Location *location = [[Location alloc] init];
		location.locationId = [[attributeDict objectForKey:@"locaiton_id"] intValue];
		location.name = [attributeDict objectForKey:@"name"];
		location.latitude = [attributeDict objectForKey:@"latitude"];
		location.longitude = [attributeDict objectForKey:@"longitude"];
		NSLog(location.name);
		[locationList addObject:location];
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//nada
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:locationList forKey:@"locationList"];
	NSLog(@"DONE WITH LOCATION XML!!");
	NSNotification *locationListNotification = [NSNotification notificationWithName:@"ReceivedLocationList" object:self userInfo:dictionary];
	[[NSNotificationCenter defaultCenter] postNotification:locationListNotification];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//nada
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//nada
}

- (void)dealloc {
	[locationList release];
    [super dealloc];
}

@end

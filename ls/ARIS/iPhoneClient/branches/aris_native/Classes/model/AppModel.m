//
//  AppModel.m
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "AppModel.h"


@implementation AppModel

@synthesize baseAppURL;
@synthesize username;
@synthesize password;
@synthesize currentModule;
@synthesize site;
@synthesize gameList;

- (BOOL)login {
	BOOL loginSuccessful = NO;
	//piece together URL
	NSString *urlString = [NSString stringWithFormat:@"%@?module=RESTLogin&site=%@&user_name=%@&password=%@",
						   baseAppURL, site, username, password];
	
	//try login
	NSURLRequest *keyRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]
												cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:60.0];
	
	NSURLResponse *response = NULL;
	NSData *loginData = [NSURLConnection sendSynchronousRequest:keyRequest returningResponse:&response error:NULL];
	
	NSString *loginResponse = [[NSString alloc] initWithData:loginData encoding:NSASCIIStringEncoding];
	
	//handle login response
	if([loginResponse isEqual:@"1"]) {
		loginSuccessful = YES;
	}
	
	return loginSuccessful;
}

-(NSURLRequest *)getURLForModule:(NSString *)moduleName {
	NSString *urlString = [NSString stringWithFormat:@"%@?module=%@&site=%@&user_name=%@&password=%@",
									baseAppURL, moduleName, site, username, password];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	return urlRequest;
}

- (void)fetchGameList {
	//init url
	NSString *urlString = [NSString stringWithFormat:@"%@?module=RESTSelectGame&site=%@&user_name=%@&password=%@",
									baseAppURL, site, username, password];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[parser setDelegate:self];
	//init parser
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];

	[parser parse];

	[parser release];
}

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
		namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
		attributes:(NSDictionary *)attributeDict {
	if(qName) {
		elementName = qName;
	}

	if ([elementName isEqualToString:@"game"]) {
		//ok, new game
		NSLog(@"NEW GAME!!");
		Game *game = [[Game alloc] init];
		game.gameId = [[attributeDict objectForKey:@"id"] intValue];
		game.name = [attributeDict objectForKey:@"name"];
		NSLog(game.name);
		[gameList addObject:game];
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//init game list array
	if(gameList != nil) {
		[gameList release];
	}
	gameList = [NSMutableArray array];
	[gameList retain];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:gameList forKey:@"gameList"];
	NSLog(@"DONE WITH XML!!");
	NSNotification *gameListNotification = [NSNotification notificationWithName:@"ReceivedGameList" object:self userInfo:dictionary];
	[[NSNotificationCenter defaultCenter] postNotification:gameListNotification];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
		namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//nada
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
   //nada
}

- (void)dealloc {
	[gameList release];
	[baseAppURL release];
	[username release];
	[password release];
	[currentModule release];
	[site release];
    [super dealloc];
}

@end

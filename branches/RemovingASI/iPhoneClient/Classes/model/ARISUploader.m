//
//  ARISUploader.m
//  ARIS
//
//  Created by Garrett Smith on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARISUploader.h"
#import "zlib.h"
#import "AppModel.h"
#import "AppServices.h"


static NSString * const BOUNDRY = @"0xKhTmLbOuNdArY";
static NSString * const FORM_FLE_INPUT = @"file";

@interface ARISUploader (Private)

- (NSURLRequest *)postRequestWithURL: (NSURL *)url
                             boundry: (NSString *)boundry
                                data: (NSData *)data;
- (NSData *)compress: (NSData *)data;
- (void)uploadSucceeded: (BOOL)success;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end


@implementation ARISUploader

@synthesize userInfo;
@synthesize responseString;
@synthesize error;

- (id)initWithURLToUpload:(NSURL*) aUrlToUpload delegate:(id)aDelegate 
             doneSelector: (SEL)aDoneSelector errorSelector: (SEL)anErrorSelector {
    if ((self = [super init])) {

        serverURL = [[AppModel sharedAppModel].serverURL 
                     URLByAppendingPathComponent:
                     [NSString stringWithFormat: @"services/%@/uploadHandler.php",kARISServerServicePackage]];
        urlToUpload = [aUrlToUpload retain];
        delegate = [aDelegate retain];
        doneSelector = aDoneSelector;
        errorSelector = anErrorSelector;        
    }
    return self;
}

- (void)upload
{
    NSData *data = [NSData dataWithContentsOfURL:urlToUpload];
    
    if (!data) {
        [self uploadSucceeded:NO];
        return;
    }
    if ([data length] == 0) {
        // There's no data, treat this the same as no file.
        [self uploadSucceeded:YES];
        return;
    }
    
    NSData *compressedData = [self compress:data];
    
    if (!compressedData || [compressedData length] == 0) {
        [self uploadSucceeded:NO];
        return;
    }
    
    NSURLRequest *urlRequest = [self postRequestWithURL:serverURL
                                                boundry:BOUNDRY
                                                   data:compressedData];
    if (!urlRequest) {
        [self uploadSucceeded:NO];
        return;
    }
    
    NSURLConnection * connection =
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (!connection) {
        [self uploadSucceeded:NO];
    }
    
    // Now wait for the URL connection to call us back.
}



- (void)dealloc
{
    [serverURL release];
    serverURL = nil;
    [urlToUpload release];
    urlToUpload = nil;
    [delegate release];
    delegate = nil;
    doneSelector = NULL;
    errorSelector = NULL;
    
    [super dealloc];
}

@end


@implementation ARISUploader (Private)


- (NSURLRequest *)postRequestWithURL: (NSURL *)url 
                             boundry: (NSString *)boundry 
                                data: (NSData *)data 
{
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:
     [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
      forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"gameID\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"\r\n%d\r\n", 
                           [AppModel sharedAppModel].currentGame.gameId] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"--%@\r\n",boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"file\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"\r\n%@\r\n", @"test.bin"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"--%@\r\n",boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	    
    //The actual file
    [postData appendData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"; filename=\"test.bin\"\r\n\r\n",FORM_FLE_INPUT] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:data];
    [postData appendData: [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    return urlRequest;
}


- (NSData *)compress: (NSData *)data 
{
    if (!data || [data length] == 0)
        return nil;
    
    // zlib compress doc says destSize must be 1% + 12 bytes greater than source.
    uLong destSize = [data length] * 1.001 + 12;
    NSMutableData *destData = [NSMutableData dataWithLength:destSize];
    
    int anError = compress([destData mutableBytes],
                         &destSize,
                         [data bytes],
                         [data length]);
    if (anError != Z_OK) {
        NSLog(@"ARISUploader: compress: zlib error on compress:%d\n", anError);
        return nil;
    }
    
    [destData setLength:destSize];
    return destData;
}

- (void)uploadSucceeded: (BOOL)success
{
    [delegate performSelector:success ? doneSelector : errorSelector
                   withObject:self];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"ARISUploader: connectionDidFinishLoading");
    [connection release];
    [self uploadSucceeded:uploadDidSucceed];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)aError {
    NSLog(@"ARISUploader: connectiondidFailWithError %@", [[aError description] UTF8String]);
    [connection release];
    [self uploadSucceeded:NO];
    self.error = aError;
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"ARISUploader: connectiondidReceiveResponse");
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"ARISUploader: connectiondidReceiveData");
    
    NSString *reply = [[[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding]
                       autorelease];
    
    if ([reply hasPrefix:@"aris"]) {
        uploadDidSucceed = YES;
        self.responseString = reply;
    }
}


@end

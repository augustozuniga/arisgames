//
//  ARISUploader.h
//  ARIS
//
//  Created by Garrett Smith on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ARISUploader : NSObject {
    NSURL* url;
    NSDictionary *userInfo;
    NSString *responseString; //Ressponse send from the server on complete or error
    NSError *error; //Our error code if there was an error or nil
}


@end

@protocol ARISUploaderDelegateProtocol <NSObject>
@required
- (void)uploader:(ARISUploader *)uploader DidfinishWithResponse: (NSString*)response;
- (void)uploader:(ARISUploader *)uploader DidFailWithError: (NSError*)error;
@end
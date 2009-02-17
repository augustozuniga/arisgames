//
//  FilesViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";

@interface FilesViewController : UIViewController {
	NSString *moduleName;
}

-(void) setModel:(AppModel *)model;

@property(copy, readwrite) NSString *moduleName;

@end

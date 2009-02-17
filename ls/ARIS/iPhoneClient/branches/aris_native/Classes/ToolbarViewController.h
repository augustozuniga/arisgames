//
//  ToolbarViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/13/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ToolbarViewController : UIViewController {
	UILabel *titleLabel;
}

-(void) setToolbarTitle:(NSString *)title;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end

//
//  FlipsideViewController.h
//  Aris
//
//  Created by Kevin Harris on 7/27/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface FlipsideViewController : UIViewController {
	IBOutlet UISwitch *locToggle;
}

-(IBAction)toggleLocationTracking:(id)sender;
@end

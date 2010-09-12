//
//  SelfRegistrationViewController.h
//  ARIS
//
//  Created by David Gagnon on 5/14/09.
//  Copyright 2009 University of Wisconsin - Madison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "WaitingIndicatorView.h"



@interface SelfRegistrationViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
	AppModel *appModel;
	WaitingIndicatorView *waitingIndicator;
	IBOutlet UIScrollView *scrollView;
	CGRect keyboardBounds; 
	NSMutableArray *entryFields;
	IBOutlet UITextField *userName;
	IBOutlet UITextField *password;
	IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UITextField *email;
	IBOutlet UIButton *createAccountButton;
	IBOutlet UILabel *messageLabel;
	
}

@property (nonatomic, retain) WaitingIndicatorView *waitingIndicator;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *entryFields;
@property (nonatomic, retain) IBOutlet UITextField *userName;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;


-(IBAction)submitButtonTouched: (id) sender;
-(void)submitRegistration;


@end

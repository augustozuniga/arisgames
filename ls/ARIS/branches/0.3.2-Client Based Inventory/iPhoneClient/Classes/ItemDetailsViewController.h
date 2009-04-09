//
//  ItemDetailsViewController.h
//  ARIS
//
//  Created by David Gagnon on 4/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";
#import "Item.h";


@interface ItemDetailsViewController : UIViewController {
	AppModel *appModel;
	Item *item;
	IBOutlet UIImageView *imageView;
	IBOutlet UITextView *descriptionView;
	IBOutlet UIButton *dropButton;
	IBOutlet UIButton *deleteButton;
	IBOutlet UIButton *backButton;
}

@property(copy, readwrite) AppModel *appModel;
@property(copy, readwrite) Item *item;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITextView *descriptionView;
@property (nonatomic, retain) UIButton *dropButton;
@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) UIButton *backButton;

- (void) setModel:(AppModel *)model;
- (void) setItem:(Item *)item;
- (IBAction)dropButtonTouchAction: (id) sender;
- (IBAction)deleteButtonTouchAction: (id) sender;
- (IBAction)backButtonTouchAction: (id) sender;

@end

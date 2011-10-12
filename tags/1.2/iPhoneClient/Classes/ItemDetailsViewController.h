//
//  ItemDetailsViewController.h
//  ARIS
//
//  Created by David Gagnon on 4/2/09.
//  Copyright 2009 University of Wisconsin - Madison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";
#import "Item.h";
#import "ARISMoviePlayerViewController.h"
#import "AsyncImageView.h"

typedef enum {
	kItemDetailsViewing,
	kItemDetailsDropping,
	kItemDetailsDestroying,
	kItemDetailsPickingUp
} ItemDetailsModeType;


@interface ItemDetailsViewController : UIViewController <UIActionSheetDelegate> {
	AppModel *appModel;
	Item *item;
	//ARISMoviePlayerViewController *mMoviePlayer; //only used if item is a video
	MPMoviePlayerViewController *mMoviePlayer; //only used if item is a video

	bool inInventory;
	bool descriptionShowing;
	IBOutlet UIToolbar *toolBar;
	IBOutlet UIBarButtonItem *dropButton;
	IBOutlet UIBarButtonItem *deleteButton;
	IBOutlet UIBarButtonItem *pickupButton;
	IBOutlet UIBarButtonItem *detailButton;
	IBOutlet UIButton *backButton;
	IBOutlet AsyncImageView *itemImageView;
	IBOutlet UIWebView *itemDescriptionView;
	IBOutlet UIScrollView *scrollView;
	UIButton *mediaPlaybackButton;
	ItemDetailsModeType mode;

}

@property(readwrite, retain) AppModel *appModel;
@property(readwrite, retain) Item *item;
@property(readwrite) bool inInventory;
@property(readwrite) ItemDetailsModeType mode;


- (IBAction)dropButtonTouchAction: (id) sender;
- (IBAction)deleteButtonTouchAction: (id) sender;
- (IBAction)backButtonTouchAction: (id) sender;
- (IBAction)pickupButtonTouchAction: (id) sender;
- (IBAction)playMovie:(id)sender;
- (IBAction)toggleDescription:(id)sender;
- (void)updateQuantityDisplay;


@end
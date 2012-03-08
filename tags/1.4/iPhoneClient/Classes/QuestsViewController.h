//
//  QuestsViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARISAppDelegate.h";
#import "AppModel.h";
#import "Quest.h"


@interface QuestsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIWebViewDelegate> {
	NSMutableArray *quests;
	NSMutableArray *questCells;
	int cellsLoaded;
	IBOutlet UITableView *tableView;
	IBOutlet UIProgressView *progressView;
	IBOutlet UILabel *progressLabel;
	int silenceNextServerUpdateCount;
	int newItemsSinceLastView;
}

@property(nonatomic, retain) NSMutableArray *quests;
@property(nonatomic, retain) NSMutableArray *questCells;


- (void)refresh;
- (void)showLoadingIndicator;
- (void)removeLoadingIndicator;
-(void)dismissTutorial;
- (void)constructCells;
- (UITableViewCell*) getCellContentViewForQuest:(Quest*)quest inSection:(int)section;
- (void)updateCellSize:(UITableViewCell*)cell;




@end
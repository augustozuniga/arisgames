//
//  FilesViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";
#import "ARISAppDelegate.h";
#import "Item.h";
#import "ItemDetailsViewController.h";

@interface InventoryListViewController : UIViewController {
	AppModel *appModel;	
	UITableView *inventoryTable;
	NSMutableArray *inventory;
}

-(void) refresh;

@property(nonatomic, retain) IBOutlet UITableView *inventoryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *inventory;

@end

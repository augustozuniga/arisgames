//
//  DeveloperViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/16/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";
#import "Location.h";

@interface DeveloperViewController : UIViewController {
	NSString *moduleName;
	AppModel *appModel;	
	
	UITableView *locationTable;
	NSMutableArray *locationTableData;
	UIButton *clearEventsButton;
	UIButton *clearItemsButton;
}

-(void) setModel:(AppModel *)model;

@property(copy, readwrite) NSString *moduleName;
@property(nonatomic, retain) IBOutlet UITableView *locationTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *locationTableData;
@property(nonatomic, retain) IBOutlet UIButton *clearEventsButton;
@property(nonatomic, retain) IBOutlet UIButton *clearItemsButton;

-(IBAction)clearEventsButtonTouched: (id) sender;
-(IBAction)clearItemsButtonTouched: (id) sender;

@end

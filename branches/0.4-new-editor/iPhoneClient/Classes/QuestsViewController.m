//
//  TODOViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "QuestsViewController.h"
#import "ARISAppDelegate.h"
#import "Quest.h"
#import "Media.h"

static NSString * const OPTION_CELL = @"quest";
static int const ACTIVE_SECTION = 0;
static int const COMPLETED_SECTION = 1;

@implementation QuestsViewController

@synthesize tableView;

//Override init for passing title and icon to tab bar
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        self.title = @"Quests";
        self.tabBarItem.image = [UIImage imageNamed:@"Quest.png"];
		quests = [[NSMutableArray alloc] init];
		appModel = [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
		
		//register for notifications
		NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
		[dispatcher addObserver:self selector:@selector(refreshViewFromModel) name:@"ReceivedQuestList" object:nil];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self refresh];		
	NSLog(@"QuestsViewController: Quests View Loaded");
}

- (void)viewDidAppear:(BOOL)animated {
	[self refresh];		
	NSLog(@"QuestsViewController: Quests View Did Appear");
}

- (void)refresh {
	NSLog(@"QuestsViewController: refresh requested");
	if (appModel.loggedIn) [appModel fetchQuestList];
}

-(void)refreshViewFromModel {
	NSLog(@"QuestsViewController: Refreshing view from model");
	
	//init quest list
	if(quests != nil) {
		[quests release];
	}
	quests = [NSMutableArray array];
	[quests retain];
	
	NSArray *activeQuestsArray = [appModel.questList objectForKey:@"active"];
	NSArray *completedQuestsArray = [appModel.questList objectForKey:@"completed"];
	
	[quests addObject:activeQuestsArray ]; //this will be at index 0
	[quests addObject:completedQuestsArray]; //this will be at index 1

	[tableView reloadData];
}


#pragma mark PickerViewDelegate selectors

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	CGRect cellFrame = CGRectMake(0, 0, 300, 60);
	CGRect iconFrame = CGRectMake(10, 10, 50, 50);
	CGRect label1Frame = CGRectMake(70, 10, 230, 25);
	CGRect label2Frame = CGRectMake(70, 35, 230, 25);
	UILabel *lblTemp;
	UIImageView *iconViewTemp;
	
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellFrame 
													reuseIdentifier:cellIdentifier] autorelease];
	
	//Setup Cell
	UIView *transparentBackground = [[UIView alloc] initWithFrame:CGRectZero];
    transparentBackground.backgroundColor = [UIColor clearColor];
    cell.backgroundView = transparentBackground;
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:label1Frame];
	lblTemp.tag = 1;
	lblTemp.textColor = [UIColor whiteColor];
	lblTemp.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	lblTemp.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Init Icon with tag 3
	iconViewTemp = [[UIImageView alloc] initWithFrame:iconFrame];
	iconViewTemp.tag = 3;
	iconViewTemp.backgroundColor = [UIColor blackColor];
	[cell.contentView addSubview:iconViewTemp];
	[iconViewTemp release];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [quests count];
}

// returns the # of rows in each component..
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *array = [quests objectAtIndex:section];
	return [array count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)nibTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	
	//Get the cell definition
	UITableViewCell *cell = [nibTableView dequeueReusableCellWithIdentifier:OPTION_CELL];	
	if(cell == nil) cell = [self getCellContentView:OPTION_CELL];
	
	//Get the quest object
	int section = indexPath.section;
	int indexWithinSection = indexPath.row;
	
	NSArray *array = [quests objectAtIndex:section];	
	Quest *quest = (Quest*)[array objectAtIndex:indexWithinSection];
	
	//Get the refrence to the cell's properties
	UILabel *cellName = (UILabel *)[cell viewWithTag:1];
	UILabel *cellDescription = (UILabel *)[cell viewWithTag:2];
	UIImageView *cellIconView = (UIImageView *)[cell viewWithTag:3];

	//Set the name and description, those are easy
	cellName.text = quest.name;
	cellDescription.text = quest.description;
	
	//Set the icon
	UIImage *icon;
	if (quest.mediaId > 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		Media *media = [appModel.mediaList objectForKey:[NSNumber numberWithInt:quest.mediaId]];
		NSData* iconData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:media.url]];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		icon = [UIImage imageWithData:iconData];
		cellIconView.image = icon;
	}
	else {
		if (section == ACTIVE_SECTION) icon = [UIImage imageNamed:@"QuestActiveIcon.png"];
		if (section == COMPLETED_SECTION) icon = [UIImage imageNamed:@"QuestCompleteIcon.png"];

	}

	cellIconView.image = icon;
	
	return cell;
}

// Customize the height of each row
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Don't do anything just yet
	//We should add a long description area here
}

- (NSString *)tableView:(UITableView *)view titleForHeaderInSection:(NSInteger)section {
	if (section == ACTIVE_SECTION) return @"Active Quests";	
	else if (section == COMPLETED_SECTION) return @"Completed Quests";
	return @"Quests";
}






















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[appModel release];
    [super dealloc];
}

@end

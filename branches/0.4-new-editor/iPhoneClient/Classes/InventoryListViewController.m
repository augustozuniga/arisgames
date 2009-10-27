//
//  FilesViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "InventoryListViewController.h"
#import "Media.h"

@implementation InventoryListViewController

@synthesize inventoryTable;
@synthesize inventory;

//Override init for passing title and icon to tab bar
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        self.title = @"Inventory";
        self.tabBarItem.image = [UIImage imageNamed:@"Inventory.png"];
		appModel = [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];

		//register for notifications
		NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
		[dispatcher addObserver:self selector:@selector(refreshViewFromModel) name:@"ReceivedInventory" object:nil];
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//Show waiting Indicator in own thread so it appears on time
	//[NSThread detachNewThreadSelector: @selector(showWaitingIndicator:) toTarget: (ARISAppDelegate *)[[UIApplication sharedApplication] delegate] withObject: @"Loading..."];	
	//[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showWaitingIndicator:@"Loading..."];
	
	[super viewDidLoad];
	NSLog(@"Inventory View Loaded");
}

-(void)refresh {
	NSLog(@"InventoryListViewController: Refresh Requested");
	[appModel fetchInventory];
}

-(void)refreshViewFromModel {
	NSLog(@"InventoryListViewController: Refresh View from Model");
	inventory = appModel.inventory;
	[inventoryTable reloadData];
	//Stop Waiting Indicator
	[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] removeWaitingIndicator];
	
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect IconFrame = CGRectMake(10, 10, 50, 50);
	CGRect Label1Frame = CGRectMake(70, 10, 290, 25);
	CGRect Label2Frame = CGRectMake(70, 33, 290, 25);
	UILabel *lblTemp;
	UIImageView *iconViewTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	//Setup Cell
	UIView *transparentBackground = [[UIView alloc] initWithFrame:CGRectZero];
    transparentBackground.backgroundColor = [UIColor clearColor];
    cell.backgroundView = transparentBackground;
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
	lblTemp.textColor = [UIColor whiteColor];
	lblTemp.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	lblTemp.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Init Icon with tag 3
	iconViewTemp = [[UIImageView alloc] initWithFrame:IconFrame];
	iconViewTemp.tag = 3;
	iconViewTemp.backgroundColor = [UIColor blackColor];
	[cell.contentView addSubview:iconViewTemp];
	[iconViewTemp release];

	return cell;
}


#pragma mark PickerViewDelegate selectors

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [inventory count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];	
	if(cell == nil) cell = [self getCellContentView:CellIdentifier];
	
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	lblTemp1.text = [[inventory objectAtIndex: [indexPath row]] name];
	
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
	NSString *description = [[inventory objectAtIndex: [indexPath row]] description];
	int targetIndex = MIN([self indexOf:'.' inString:description] + 1, 
						  [description length] - 1);
	lblTemp2.text = [description substringToIndex:targetIndex];
	
	UIImageView *iconView = (UIImageView *)[cell viewWithTag:3];
	UIImage *icon;
	
	Item *item = [inventory objectAtIndex:[indexPath row]];
	Media *media = [appModel.mediaList objectForKey:[NSNumber numberWithInt:item.mediaId]];
	
	/*
	//Load the icon from the server
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSData* iconData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[[inventory objectAtIndex:[indexPath row]] iconURL]]];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	icon = [UIImage imageWithData:iconData];
	*/

	if (item.iconMediaId != 0) {
		Media *iconMedia = [appModel.mediaList objectForKey:[NSNumber numberWithInt:item.iconMediaId]];
		//NSLog(@"icon url: %@",iconMedia.url);
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconMedia.url]];
		icon = [UIImage imageWithData:imageData];
	} else {
		//Load the Default
		if ([media.type isEqualToString: @"Image"]) icon = [UIImage imageNamed:@"defaultImageIcon.png"];
		if ([media.type isEqualToString: @"Audio"]) icon = [UIImage imageNamed:@"defaultAudioIcon"];
		if ([media.type isEqualToString: @"Video"]) icon = [UIImage imageNamed:@"defaultVideoIcon"];
	}
	
	iconView.image = icon;

	return cell;
}
					 
 - (unsigned int) indexOf:(char) searchChar inString:(NSString *)searchString {
	NSRange searchRange;
	searchRange.location = (unsigned int) searchChar;
	searchRange.length = 1;
	NSRange foundRange = [searchString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithRange:searchRange]];
	return foundRange.location;	
}

// Customize the height of each row
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	Item *selectedItem = [inventory objectAtIndex:[indexPath row]];
	NSLog(@"Displaying Detail View: %@", selectedItem.name);
	
	ItemDetailsViewController *itemDetailsViewController = [[ItemDetailsViewController alloc] 
															initWithNibName:@"ItemDetailsView" bundle:[NSBundle mainBundle]];
	itemDetailsViewController.appModel = appModel;
	itemDetailsViewController.item = selectedItem;
	itemDetailsViewController.navigationItem.title = selectedItem.name;
	itemDetailsViewController.inInventory = YES;

	//Put the view on the screen
	[[self navigationController] pushViewController:itemDetailsViewController animated:YES];
	
	[itemDetailsViewController release];
	
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[appModel release];
    [super dealloc];
}
@end

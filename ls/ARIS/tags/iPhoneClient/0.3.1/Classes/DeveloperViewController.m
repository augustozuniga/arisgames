//
//  DeveloperViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/16/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "DeveloperViewController.h"

@implementation DeveloperViewController

@synthesize moduleName;
@synthesize locationTable;
@synthesize locationTableData;
@synthesize clearEventsButton;
@synthesize clearItemsButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	moduleName = @"RESTDeveloper";
	NSLog(@"Developer loaded");
}

- (void)viewDidAppear {
}


-(void) setModel:(AppModel *)model {
	if(appModel != model) {
		[appModel release];
		appModel = model;
		[appModel retain];
	}
	
	[appModel fetchLocationList];
	locationTableData = appModel.locationList;
	
	//refresh the picker now that we have Model data available
	[locationTable reloadData];
	
	NSLog(@"model set for DEV");
}

#pragma mark IB Button Actions

-(IBAction)clearEventsButtonTouched: (id) sender{
	//Fire off a request to the REST Module and display an alert when it is successfull
	NSString *baseURL = [appModel getURLStringForModule:moduleName];
	NSString *URLparams = @"&event=deleteAllEvents";
	NSString *fullURL = [ NSString stringWithFormat:@"%@%@", baseURL, URLparams];
	
	NSLog([NSString stringWithFormat:@"Deleting all Events for this Player on server: %@", fullURL ]);
	
	NSString *result = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fullURL]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success" message: result delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	[alert show];
	
	[result release];
	[alert release];
	
}

-(IBAction)clearItemsButtonTouched: (id) sender{
	//Fire off a request to the REST Module and display an alert when it is successfull
	NSString *baseURL = [appModel getURLStringForModule:moduleName];
	NSString *URLparams = @"&event=deleteAllItems";
	NSString *fullURL = [ NSString stringWithFormat:@"%@%@", baseURL, URLparams];

	NSLog([NSString stringWithFormat:@"Deleting all Items for this Player on server: %@", fullURL ]);
	
	NSString *result = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fullURL]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success" message: result delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	[alert show];
	
	[result release];
	[alert release];

}


#pragma mark PickerViewDelegate selectors

//See http://www.iphonedevcentral.org/tutorials.php?page=ViewTutorial&id=36&uid=48763428 for a tutorial


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [locationTableData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Location *loc = [locationTableData objectAtIndex: [indexPath row]];
	cell.text = loc.name;
	cell.textColor = [[UIColor alloc] initWithWhite:1.0 alpha:1.0]; 	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Location *selectedLocation = [locationTableData objectAtIndex:[indexPath row]];
	
	NSLog([NSString stringWithFormat:@"Location Selected. Forcing appModel to Latitude: %@ Longitude: %@", selectedLocation.latitude, selectedLocation.longitude]);
	appModel.lastLatitude = selectedLocation.latitude;
	appModel.lastLongitude = selectedLocation.longitude;
	
	NSLog(@"Updating Server Location and Fetching Nearby Location List");
	[appModel updateServerLocationAndfetchNearbyLocationList];
	
	//refresh?
	[locationTable reloadData];
}


#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[appModel release];
	[moduleName release];
    [super dealloc];
}


@end

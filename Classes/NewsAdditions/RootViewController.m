//
//  RootViewController.m
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "LatestChattyAppDelegate.h"


@implementation RootViewController


- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	//load up the stuff	
	theReader = [[RSSReader alloc] init];
	posts = [theReader getNewsPosts];
	
	//hop to LC.x
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"lc_startup"]){
		[self latestChatty:self];
	}
	//NSLog(@"posts count %i", [posts count] );
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@"posts count %i", [posts count] );
	return [posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"wtf?");
	static NSString *MyIdentifier = @"NPIdentifer";
	
	JFNewsPostCell* cell = (JFNewsPostCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[JFNewsPostCell alloc] initWithFrame:CGRectMake( 0,0,320, 200) reuseIdentifier:MyIdentifier] autorelease];
	}
	// Set up the cell
	//NSLog(@"setting up with title: %@", [[posts objectAtIndex:indexPath.row] title] );
	//cell.text = [[posts objectAtIndex:indexPath.row] title];
	[cell setColor:indexPath.row%2];
	[cell buildCellForPost:[posts objectAtIndex:indexPath.row]];
	return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 // Navigation logic
	 //ok here we go
	 //if( postView ) [postView release];
	 postView = [[ExternalWebViewController alloc] initWithNewsPost:[posts objectAtIndex:indexPath.row]];
	 //else [postView updateForPost:[posts objectAtIndex:indexPath.row]];
	 [[self navigationController] pushViewController:postView animated:YES];
	 [postView release];
	 [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
 Override if you support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}	
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}	
}
*/


/*
 Override if you support conditional editing of the list
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}
*/


/*
 Override if you support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
 Override if you support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}
 */ 

//-(UITableView*) loadView
//{
	//return tableView;
//}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[chattyView release];
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[theReader release];
	[posts release];
	[super dealloc];
}

-(IBAction) refresh:(id)sender
{
	NSLog(@"sup.");
	posts = [theReader getNewsPosts];
	[tableView reloadData];
}

-(IBAction)latestChatty:(id)sender
{
	if( !chattyView ) chattyView = [[ChattyViewController alloc] initWithChattyId:0];
	if( sender == self ) [[self navigationController] pushViewController:chattyView animated:NO];
	else [[self navigationController] pushViewController:chattyView animated:YES];
	[chattyView release];
}

@end


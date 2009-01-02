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
	stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(refresh:)];
	[self refresh:self];
	refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	//[toolBar addSubview:stopButton];
	if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"startup_destination"] isEqualToString:@"chatty"]){
		[self latestChatty:self];
	}
}

-(void)dataReady
{
	//posts = [theReader getNewsPosts];
	//hop to LC.x
	//[self refresh:self];
	posts = [theReader getNewsPosts];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[tableView reloadData];
	NSLog(@"Done.");
	[toolBar setItems:[NSArray arrayWithObject:refreshButton]];
	[loadView removeFromSuperview];
	tableView.userInteractionEnabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 76.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [posts count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JFNewsPostCell* cell = (JFNewsPostCell*)[tableView dequeueReusableCellWithIdentifier:@"storyCell"];
	if (cell == nil) {
		cell = [[[JFNewsPostCell alloc] initWithFrame:CGRectMake(0, 0, 320, 200) reuseIdentifier:@"storyCell"] autorelease];
	}
	// Set up the cell
	//NSLog(@"setting up with title: %@", [[posts objectAtIndex:indexPath.row] title] );
	//cell.text = [[posts objectAtIndex:indexPath.row] title];
	[cell setColor:indexPath.row % 2];
	[cell buildCellForPost:[posts objectAtIndex:indexPath.row]];
	return cell;
}


 - (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 postView = [[ExternalWebViewController alloc] initWithNewsPost:[posts objectAtIndex:indexPath.row]];
	 [[self navigationController] pushViewController:postView animated:YES];
	 [postView release];
	 NSLog(@"PostView retainCount: %i", [postView retainCount] );
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
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	NSLog(@"rootviewdealloc");
	[theReader release];
	[posts release];
	[refreshButton release];
	[stopButton release];
	[super dealloc];
}

- (IBAction)refresh:(id)sender {
	NSLog(@"Refreshing...");
	if( sender == refreshButton || sender == self ){
		[toolBar setItems:[NSArray arrayWithObject:stopButton]];
		if (loadView) [loadView release];
		loadView = [[LoadingView alloc] initWithFrame:CGRectZero];
		//CGRect tableViewFrame = self.tableView;
		[loadView setupViewWithFrame:tableView.frame];
		[self.view addSubview:loadView];
		if(theReader) [theReader release];
		theReader = [[RSSReader alloc] initWithDelegate:self];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		tableView.userInteractionEnabled = NO;
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	else{
		NSLog(@"stopping!");
		[theReader stopLoading];
		[toolBar setItems:[NSArray arrayWithObject:refreshButton]];
		[loadView removeFromSuperview];
		self.navigationItem.rightBarButtonItem.enabled = YES;
		posts = nil;
		[tableView reloadData];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

- (IBAction)latestChatty:(id)sender {
	//NSLog(@"%i", [chattyView retainCount] );

	if (!chattyView ){
		chattyView = [[ChattyViewController alloc] initWithChattyId:0];
	}
	if (sender == self){ [[self navigationController] pushViewController:chattyView animated:NO];
	}
	else{ [[self navigationController] pushViewController:chattyView animated:YES];
	}
	//NSLog(@"%i", [chattyView retainCount] );
	while( [chattyView retainCount] != 1 ) [chattyView release];
	chattyView = nil;
	//[chattyView release];
}

@end


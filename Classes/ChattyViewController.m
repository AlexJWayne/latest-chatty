//
//  ChattyViewController.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/31/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "ChattyViewController.h"
#import "LatestChattyAppDelegate.h"


@implementation ChattyViewController


- (id)initWithChattyId:(int)aChatId {
	chatId = aChatId;
	self = [self initWithNibName:@"ChattyViewController" bundle:[NSBundle mainBundle]];
	
	return self;
}


- (void)viewDidLoad {
	// Compose button
	UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
																				 target:self
																				 action:@selector(compose:)];
	self.navigationItem.rightBarButtonItem = composeItem;
	[composeItem release];
	
	stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(refresh:)];
	refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	
	// Fetch feed
	[self refresh:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([feed hasMorePages]) {
		return [[feed posts] count] + 1;
	} else {
		return [[feed posts] count];
	}
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	RootPostCellView *cell;
	if (indexPath.row < [[feed posts] count]) {
		Post *post = [[feed posts] objectAtIndex:indexPath.row];
		
		cell = (RootPostCellView *)[tableView dequeueReusableCellWithIdentifier:@"rootPostCell"];
		if (cell == nil) {
			cell = [[RootPostCellView alloc] initForPost];
		}
		
		[cell updateWithPost:post];
	} else {
		cell = [[RootPostCellView alloc] initLoadMore];
	}
	
	cell.striped = (indexPath.row % 2 == 1);
	return (UITableViewCell *)cell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Tapped a post cell
	if (indexPath.row < [[feed posts] count]) {
		RootPostCellView *cell = (RootPostCellView *)[tableView cellForRowAtIndexPath:indexPath];
		[cell setLoading:YES];
		//we'll be fucked up if it's loading still; on a refresh
		if(feed) [feed abortLoadIfInProgress];
		Post *rootPost = [[feed posts] objectAtIndex:indexPath.row];
		[[Post alloc] initWithThreadId:rootPost.postId delegate:self];
		
		// Tapped the load more cell
	} else {
		RootPostCellView *cell = (RootPostCellView *)[tableView cellForRowAtIndexPath:indexPath];
		[cell setLoading:YES];
		[feed loadNextPage];
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)feedDidFinishLoading {
	[tableView reloadData];
	if (feed.lastPageLoaded == 1 && ([tableView.visibleCells count] != 0) ) {
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	self.title = [feed storyName];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[loadView removeFromSuperview];
	[toolBar setItems:[NSArray arrayWithObject:refreshButton]];
	tableView.userInteractionEnabled = YES;
}

- (void)didFinishLoadingThread:(Post *)post {
	// create the detail view controller
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithStoryId:feed.storyId rootPost:post];
	
	// Push the detail view controller onto the navigation stack
	[[self navigationController] pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
	// Remove loading status from tapped cell
	[(RootPostCellView *)[tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]] setLoading:NO];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	//abort a possible load in progress
	if(feed) [feed abortLoadIfInProgress];
}

- (void)viewDidDisappear:(BOOL)animated {
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
	NSLog(@"Received memory warning");
}


- (void)dealloc {
	//NSLog(@"DEALLOC");
	if(feed)[feed release];
	[refreshButton release];
	[stopButton	release];
	[super dealloc];
}


- (void)refresh:(id)sender {
	if( sender == refreshButton || sender == self ){
		[toolBar setItems:[NSArray arrayWithObject:stopButton]];
		if( loadView ) [loadView release];
		loadView = [[LoadingView alloc] initWithFrame:CGRectZero];
		[loadView setupViewWithFrame:self.view.frame];
		[self.view addSubview:loadView];
		tableView.userInteractionEnabled = NO;	
		
		[feed release];
		//feed = [[Feed alloc] initWithLatestChattyAndDelegate:self];
		if( chatId == 0 ){
			feed = [[Feed alloc] initWithLatestChattyAndDelegate:self];
		}
		else{
			feed = [[Feed alloc] initWithStoryId:chatId delegate:self];
		}
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	else{
		NSLog(@"stopping!");
		if(feed) [feed abortLoadIfInProgress];
		[toolBar setItems:[NSArray arrayWithObject:refreshButton]];
		[loadView removeFromSuperview];
		feed = nil;
		[tableView reloadData];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

- (IBAction)compose:(id)sender {
	ComposeViewController *composeViewController = [[ComposeViewController alloc] initWithStoryId:feed.storyId];
	[[self navigationController] pushViewController:composeViewController animated:YES];
	[composeViewController release];
}


@end


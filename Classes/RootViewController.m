//
//  RootViewController.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/31/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "LatestChattyAppDelegate.h"


@implementation RootViewController


- (void)viewDidLoad {
  // Compose button
  UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                               target:self
                                                                               action:@selector(compose:)];
  self.navigationItem.rightBarButtonItem = composeItem;
  [composeItem release];
  
  // Fetch feed
  [self refresh:nil];
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
  if (feed.lastPageLoaded == 1) {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
  }
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
  
  self.title = [feed storyName];
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
  [feed release];
	[super dealloc];
}






- (void)refresh:(id)sender {
  [feed release];
  feed = [[Feed alloc] initWithLatestChattyAndDelegate:self];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (IBAction)compose:(id)sender {
  ComposeViewController *composeViewController = [[ComposeViewController alloc] initWithStoryId:feed.storyId];
  [[self navigationController] pushViewController:composeViewController animated:YES];
  [composeViewController release];
}


@end


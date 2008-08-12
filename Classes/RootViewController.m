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
  // Refresh button
  refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                               target:self
                                                                               action:@selector(refresh:)];
  self.navigationItem.leftBarButtonItem = refreshButton;
  
  // This replaces the refresh button while its loading data
  refreshButtonLoading = [[UIBarButtonItem alloc] initWithCustomView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
  
  
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
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


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
}

- (void)feedDidFinishLoading {
  [[self tableView] reloadData];
  if (feed.lastPageLoaded == 1) {
    [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
  }
  [[self tableView] deselectRowAtIndexPath:[[self tableView] indexPathForSelectedRow] animated:YES];
  
  // Replace refresh loader with a working refresh button
  self.navigationItem.leftBarButtonItem = refreshButton;
  [(UIActivityIndicatorView *)refreshButtonLoading.customView stopAnimating];
}

- (void)threadDidFinishLoadingThread:(Post *)post {
  // create the detail view controller
  DetailViewController *detailViewController = [[DetailViewController alloc] initWithStoryId:feed.storyId rootPost:post];
  
  // Push the detail view controller onto the navigation stack
  [[self navigationController] pushViewController:detailViewController animated:YES];
  [detailViewController release];
  
  // Remove loading status from tapped cell
  [(RootPostCellView *)[[self tableView] cellForRowAtIndexPath:[[self tableView] indexPathForSelectedRow]] setLoading:NO];
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
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [refreshButton release];
	[super dealloc];
}






- (void)refresh:(id)sender {
  [feed release];
  feed = [[Feed alloc] initWithLatestChattyAndDelegate:self];
  self.navigationItem.leftBarButtonItem = refreshButtonLoading;
  [(UIActivityIndicatorView *)refreshButtonLoading.customView startAnimating];
}

- (IBAction)compose:(id)sender {
  ComposeViewController *composeViewController = [[ComposeViewController alloc] initWithStoryId:feed.storyId];
  [[self navigationController] pushViewController:composeViewController animated:YES];
  [composeViewController release];
}


@end


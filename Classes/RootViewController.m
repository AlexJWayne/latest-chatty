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
  // Fetch feed
  feed = [[Feed alloc] initWithLatestChatty];
  
  // Refresh button
  UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                               target:self
                                                                               action:@selector(refresh:)];
  self.navigationItem.leftBarButtonItem = refreshItem;
  [refreshItem release];
  
  
  // Compose button
  UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                               target:self
                                                                               action:@selector(compose:)];
  self.navigationItem.rightBarButtonItem = composeItem;
  [composeItem release];
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
	
  /*
	static NSString *MyIdentifier = @"indexCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *contentView = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 290, 60)];
    contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    contentView.numberOfLines = 2;
    contentView.font = [UIFont systemFontOfSize:14];
    contentView.minimumFontSize = 14;
    contentView.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [cell.contentView addSubview:contentView];
	}
   */
	
  UITableViewCell *cell;
	if (indexPath.row < [[feed posts] count]) {
    cell = [[RootPostCellView alloc] initWithPost:[[feed posts] objectAtIndex:indexPath.row]];
  } else {
    cell = [[RootPostCellView alloc] initLoadMore];
  }
  
  // This doesn't work right now
  if (indexPath.row % 2 == 1) {
    [cell.backgroundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.05]];
  }
    
  return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row < [[feed posts] count]) {
    Post *post = [[feed posts] objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithStoryId:feed.storyId rootPost:post];

    // Push the detail view controller
    [[self navigationController] pushViewController:detailViewController animated:YES];
    [detailViewController release];
  } else {
    [feed loadNextPage];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
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
	[super dealloc];
}






- (void)refresh:(id)sender {
  [feed release];
  feed = [[Feed alloc] init];
  [[self tableView] reloadData];
}

- (IBAction)compose:(id)sender {
  ComposeViewController *composeViewController = [[ComposeViewController alloc] initWithStoryId:feed.storyId];
  [[self navigationController] pushViewController:composeViewController animated:YES];
  [composeViewController release];
}


@end


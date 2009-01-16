//
//  LatestChattyAppDelegate.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (id)initWithStoryId:(int)aStoryId rootPost:(Post *)post; {
  [self initWithNibName:@"DetailViewController" bundle:nil];
  storyId = aStoryId;
  currentRoot = post;
  currentPost = currentRoot;
  currentPostIndex = 0;
  tableIsVisible = YES;
  [self updateViews];
  
  self.title = @"Thread";
  
  // Reply button
	UIBarButtonItem *replyItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                              target:self
                                                                              action:@selector(reply:)];
	self.navigationItem.rightBarButtonItem = replyItem;
	[replyItem release];
   
  return self;
}

- (void)viewDidLoad {
  [self showCurrentThread];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return [LatestChattyAppDelegate shouldAllowRotationTo:interfaceOrientation];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [postView release];
  //[currentRoot release];
  [super dealloc];
}



// UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[[UIView alloc] init] autorelease];
  headerView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
  return headerView;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return [currentRoot replyCount] + 1;
}

- (NSInteger)tableView:(UITableView *)aTableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return [currentRoot postAtIndex:indexPath.row].depth - currentRoot.depth;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadPreviewCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"threadPreviewCell"];
  }
  
  Post *post = [currentRoot postAtIndex:indexPath.row];
  
  // Most recent 10 posts are whiter than the rest
  float alpha = 0.6;
  if (post.recentIndex < 10) {
    alpha = alpha + ((1.0 - alpha) / 10) * (float)(10 - (post.recentIndex));
  }
  cell.textColor = [UIColor colorWithWhite:1.0 alpha:alpha];
  
  // the latest post is bold
  if (post.recentIndex == 0) {
    cell.font = [UIFont boldSystemFontOfSize:14.0];
  } else {
    cell.font = [UIFont systemFontOfSize:14.0];
  }
  
  // Set preview text
  cell.text = [post preview];
  
  return cell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  currentPostIndex = indexPath.row;
  [self showPost:[currentRoot postAtIndex:currentPostIndex]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if (scrollView == tableView) {
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentPostIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
  }
}
// End UITableViewDelegate methods


// UIWebViewDelegate methods
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    ExternalWebViewController *controller = [[ExternalWebViewController alloc] initWithRequest:request];
    [[self navigationController] pushViewController:controller animated:YES];
    [controller release];
    return NO;
  }
  
  return YES;
}
// End UIWebViewDelegate methods


- (void)showCurrentThread {
  [self showPost:currentRoot];
  [tableView reloadData];
  [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                         animated:NO
                   scrollPosition:UITableViewScrollPositionTop];
}

- (void)showPost:(Post *)post {
  currentPost = post;
  [postView loadHTMLString:[[currentPost html] stringByReplacingOccurrencesOfString:@"target=\"_blank\"" withString:@""]
                   baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.shacknews.com/laryn.x?id=%d", storyId]]];
}

- (void)updateViews {
  int height;
  int width;
  
  if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
    height = 372;
    width  = 320;
  } else {
    height = 224;
    width  = 480;
  }
  
  if (tableIsVisible) {
    tableView.frame = CGRectMake(0, height/2, width, height/2);
    postView.frame  = CGRectMake(0,        0, width, height/2);
  } else {
    tableView.frame = CGRectMake(0,  height , width, 0);
    postView.frame  = CGRectMake(0,        0, width, height);
  }
  
  toolbarView.frame = CGRectMake(toolbarView.frame.origin.x, height, width, toolbarView.frame.size.height);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [self updateViews];
}

- (IBAction)toggleTable:(id)sender {
  tableIsVisible = !tableIsVisible;
  
  [UIView beginAnimations:@"toggle" context:NULL];
  [self updateViews];
  [UIView commitAnimations];
}

- (IBAction)prevReply:(id)sender {
  if (currentPostIndex > 0) {
    currentPostIndex--;
    [self showRow:currentPostIndex];
  }  
}

- (IBAction)nextReply:(id)sender {
  if (currentPostIndex < [currentRoot replyCount]) {
    currentPostIndex++;
    [self showRow:currentPostIndex];
  }
}

- (void)showRow:(int)row {
  currentPost = [currentRoot postAtIndex:row];
  [self showPost:currentPost];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentPostIndex inSection:0];
  [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentPostIndex inSection:0]
                         animated:NO
                   scrollPosition:UITableViewScrollPositionNone];
  [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


- (IBAction)refresh:(id)sender {
  if (!loading) {
    NSLog(@"Refreshing...");
    loading = YES;
    currentRoot = [[Post alloc] initWithThreadId:currentRoot.postId delegate:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];    
  }
}

- (void)refreshAndPop {
  [self refresh:nil];
  popAfterLoad = YES;
}

- (void)didFinishLoadingThread:(Post *)post {
  currentPost = currentRoot;
  currentPostIndex = 0;
  [self showPost:currentRoot];
  [self updateViews];
  [tableView reloadData];
  
  [refreshButtonLoading stopAnimating];
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"Done refreshing...");
  loading = NO;
  
  if (popAfterLoad) {
    [self.navigationController popViewControllerAnimated:YES];
  }
  
  popAfterLoad = NO;
}

- (IBAction)reply:(id)sender {
  ComposeViewController *composeViewController = [[ComposeViewController alloc] initWithStoryId:storyId parentPost:currentPost];
  [[self navigationController] pushViewController:composeViewController animated:YES];
  [composeViewController release];
}

- (IBAction)tag:(id)sender {
	UIActionSheet *dialog = [[UIActionSheet alloc] initWithTitle:@"Tag Post"
                                                      delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                             otherButtonTitles:@"LOL", @"INF", @"Shackmark", nil];
	dialog.actionSheetStyle = UIBarStyleBlackTranslucent;
	dialog.destructiveButtonIndex = -1;
	[dialog showInView:self.view];
	[dialog release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"] length] == 0) {
    [LatestChattyAppDelegate showErrorAlertNamed:@"Authentication Failed"];
    
  } else {
    switch (buttonIndex) {
      case 0:
        [self tagWithTag:@"lol"]; break;
      case 1:
        [self tagWithTag:@"inf"]; break;
      case 2:
        [self tagWithTag:@"mark"]; break;
    }    
  }
}

- (void)tagWithTag:(NSString *)tag {
  NSURL *url = nil;
  //I dunno if this is exactly a great way to do this.  But really, this is probably the last thing that's going to get tagged, so it's probably fine.
  if (tag == @"mark") {
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://socksandthecity.net/shackmarks/shackmark.php?user=%@&id=%d&version=20080528",
                                [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"], currentPost.postId]];    
  } else {
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://lmnopc.com/greasemonkey/shacklol/report.php?who=%@&what=%d&tag=%@&version=-1",
                                [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"], currentPost.postId, tag]];
  }
  
  if (url) {
    NSLog(@"Tagged URL: %@", [url relativeString]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:nil];    
  }
}

@end

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
  currentRoot = [[Post alloc] initWithThreadId:(int)post.postId];
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
  [self showCurrentThread];
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
  [postView release];
  [currentRoot release];
	[super dealloc];
}



// UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return [currentRoot replyCount] + 1;
}

- (NSInteger)tableView:(UITableView *)aTableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [currentRoot postAtIndex:indexPath.row].depth - currentRoot.depth;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  cell.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
  
  Post *post = [currentRoot postAtIndex:indexPath.row];
  
  cell.text = [post preview];
  
  if (indexPath.row == 0) {
    cell.font = [UIFont boldSystemFontOfSize:14.0];
  } else {
    cell.font = [UIFont systemFontOfSize:14.0];
  }
  
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
    [[UIApplication sharedApplication] openURL:[request URL]];
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
                   baseURL:[NSURL URLWithString:@"http://thread-detail.shacknews.com/"]];
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
    currentPost = [currentRoot postAtIndex:currentPostIndex];
    [self showPost:currentPost];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentPostIndex inSection:0]
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
  }  
}

- (IBAction)nextReply:(id)sender {
  if (currentPostIndex < [currentRoot replyCount]) {
    currentPostIndex++;
    currentPost = [currentRoot postAtIndex:currentPostIndex];
    [self showPost:currentPost];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentPostIndex inSection:0]
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
  }
}

- (IBAction)refresh:(id)sender {
  int postId = (int)currentRoot.postId;
  [currentRoot release];
  
  currentRoot = [[Post alloc] initWithThreadId:postId];
  currentPost = currentRoot;
  currentPostIndex = 0;
  [self showPost:currentRoot];
  [self updateViews];
  [tableView reloadData];
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
    //Should probably make some uniform function to display errors, no?
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Username"
                                                    message:@"It appears you credentials aren't right.  Go your device settings and set your username and password for the \"LatestChatty\" application."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
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

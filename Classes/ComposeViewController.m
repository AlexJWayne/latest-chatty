//
//  ComposeViewController.m
//  LatestChatty
//
//  Created by Alex Wayne on 8/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ComposeViewController.h"


@implementation ComposeViewController

- (id)initWithStoryId:(int)aStoryId {
  self = [self initWithNibName:@"ComposeViewController" bundle:nil];
  self.title = @"Compose";
  storyId = aStoryId;
	return self;
}

- (id)initWithStoryId:(int)aStoryId parentPost:(Post *)aPost {
  self = [self initWithStoryId:aStoryId];
  parentPost = aPost;
	return self;
}

/*
- (void)loadView {

}
*/

- (void)viewDidLoad {
  if (parentPost) {
    parentPreview.text = parentPost.preview;
  } else {
    parentPreview.text = @"New Post";
  }
  UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(sendPost:)];
	self.navigationItem.rightBarButtonItem = sendButton;
	[sendButton release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}



- (IBAction)toggleKeyboard:(id)sender {
  [postContent resignFirstResponder];  
}

- (IBAction)tag:(id)sender {
  NSDictionary *tagLookup = [[NSDictionary dictionaryWithObjectsAndKeys:
                              @"r{}r", @"Red",
                              @"g{}g", @"Green",
                              @"b{}b", @"Blue",
                              @"y{}y", @"Yellow",
                              @"e[]e", @"Olive",
                              @"l[]l", @"Lime",
                              @"n[]n", @"Orange",
                              @"p[]p", @"Pink",
                              @"/[]/", @"Italic",
                              @"b[]b", @"Bold",
                              @"q[]q", @"Quote",
                              @"s[]s", @"Small",
                              @"_[]_", @"Underline",
                              @"-[]-", @"Strike",
                              @"o[]o", @"Spoiler",
                              @"/{{}}/", @"Code",
                              nil] autorelease];
  
  NSString *append = [tagLookup valueForKey:((UIButton *)sender).currentTitle];
  
  if (append) {
    int textLen = [[postContent text] length];
    postContent.text = [[postContent text] stringByAppendingString:append];
    [postContent becomeFirstResponder];
    [postContent setSelectedRange:NSMakeRange(([append length] == 4 ? textLen + 2 : textLen + 3), 0)];
  }
}

- (IBAction)sendPost:(id)sender {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit Post" message:@"All ready to submit your post?"
                                                 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) [self sendPostConfirmed];
}

- (void)sendPostConfirmed {
  // Create the request
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  [request setURL:[[NSURL URLWithString:@"http://www.shacknews.com/extras/post_laryn_iphone.x"] autorelease]];
  
  // Set request body and HTTP method
  NSString *usernameString = [self urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]];
  NSString *passwordString = [self urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"]];
  NSString *bodyString     = [self urlEscape:postContent.text];
  NSString *parentId       = [NSString stringWithFormat:@"%d", parentPost.postId];
  if ([parentId isEqualToString:@"0"]) parentId = @"";
  
  
  NSString *postBody = [NSString stringWithFormat:@"body=%@&iuser=%@&ipass=%@&parent=%@&group=%d", bodyString, usernameString, passwordString, parentId, storyId];
  [request setHTTPBody:[postBody dataUsingEncoding: NSASCIIStringEncoding]];
  [request setHTTPMethod:@"POST"];
  
  NSLog(postBody);
  
  // Send the request
  NSHTTPURLResponse *response;
  NSString *responseBody = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]
                                                 encoding:NSASCIIStringEncoding];
  
  NSLog(responseBody);
  
  // Success! Return to previous view
  if ([responseBody rangeOfString:@"navigate_page_no_history"].location != NSNotFound) {
    if (parentPost) {
      DetailViewController *viewController = [[self navigationController].viewControllers objectAtIndex:[[self navigationController].viewControllers count] - 2];
      [viewController refreshAndPop];
    } else {
      RootViewController *viewController = [[self navigationController].viewControllers objectAtIndex:[[self navigationController].viewControllers count] - 2];
      [viewController refresh:nil];
      [[self navigationController] popViewControllerAnimated:YES];
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:@"Sending"];
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleBordered];
    
  // Authentication Failure, display alert
  } else if ([responseBody rangeOfString:@"You must be logged in to post"].location != NSNotFound) {
    [LatestChattyAppDelegate showErrorAlertNamed:@"Authentication Failed"];
    
  // PRL'd, display alert
  } else if ([responseBody rangeOfString:@"Please wait a few minutes"].location != NSNotFound) {
    [LatestChattyAppDelegate showErrorAlertNamed:@"Post Rate Limited"];
  
  // Too short, display alert
  } else if ([responseBody rangeOfString:@"Please post something with more than 5 characters"].location != NSNotFound) {
    [LatestChattyAppDelegate showErrorAlertNamed:@"Post too Short"];
    
  // Something unexpected happened, display alert
  } else {
    [LatestChattyAppDelegate showErrorAlertNamed:@"Unhandled Error"];
    
  }
  
}

- (NSString *)urlEscape:(NSString *)string {
  return (NSString *)CFURLCreateStringByAddingPercentEscapes(
    NULL,
    (CFStringRef)string,
    NULL,
    (CFStringRef)@";/?:@&=+$,",
    kCFStringEncodingUTF8
  );
}


@end

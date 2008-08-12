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
  // Find the proper URL based on whether this is a root post or reply
  NSString *urlString;
  if (parentPost) {
    urlString = [Feed urlStringWithPath:[NSString stringWithFormat:@"create/%d/%d.xml", storyId, parentPost.postId]];
  } else {
    urlString = [Feed urlStringWithPath:[NSString stringWithFormat:@"create/%d.xml", storyId]];
  }
  
  // Create the request
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  [request setURL:[NSURL URLWithString:urlString]];
  
  // Set request body and HTTP method
  NSString *usernameString = [self urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]];
  NSString *passwordString = [self urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"]];
  NSString *bodyString     = [self urlEscape:postContent.text];
    
  NSString *postBody = [NSString stringWithFormat:@"body=%@&username=%@&password=%@", bodyString, usernameString, passwordString];
  [request setHTTPBody:[postBody dataUsingEncoding: NSASCIIStringEncoding]];
  [request setHTTPMethod:@"POST"];
  
  // Send the request
  NSHTTPURLResponse *response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  int statusCode = (int)[response statusCode];
  
  // Success! Return to previous view
  if (statusCode == 201) {
    /*
    if (parentPost) {
      DetailViewController *viewController = [[self navigationController].viewControllers objectAtIndex:[[self navigationController].viewControllers count] - 2];
      [viewController refresh:nil];
    } else {
      RootViewController *viewController = [[self navigationController].viewControllers objectAtIndex:[[self navigationController].viewControllers count] - 2];
      [viewController refresh:nil];
    }
     */
    [[self navigationController] popViewControllerAnimated:YES];
    
  // Authentication Failure, display alert
  } else if (statusCode == 403) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed"
                                                    message:@"It appears you credentials aren't right.  Go your device settings and set your username and password for the \"LatestChatty\" application."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  
  // Something unexpected happened, display alert
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unexpected Error"
                                                    message:@"Something has gone terribly wrong.  Sorry for the inconvience, but this can't be posted right now."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
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

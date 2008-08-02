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
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */


- (void)viewDidLoad {
  if (parentPost) {
    parentPreview.text = parentPost.preview;
  } else {
    parentPreview.text = @"New Post";
  }
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






- (IBAction)sendPost:(id)sender {
  
  // Find the proper URL based on whether this is a root post or reply
  NSString *urlString;
  if (parentPost) {
    urlString = [NSString stringWithFormat:@"http://latestchatty.beautifulpixel.com/create/%d/%d.xml", storyId, parentPost.postId];
  } else {
    urlString = [NSString stringWithFormat:@"http://latestchatty.beautifulpixel.com/create/%d.xml", storyId];
  }
  
  // Create the quest for the URL
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  [request setURL:[NSURL URLWithString:urlString]];
  
  // Set request body and HTTP method
  NSString *usernameString = [[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"] autorelease];
  NSString *passwordString = [[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"] autorelease];
  
  NSString *postBody = [NSString stringWithFormat:@"body=%@&username=%@&password=%@", postContent.text, usernameString, passwordString];
  [request setHTTPBody:[postBody dataUsingEncoding: NSASCIIStringEncoding]];
  [request setHTTPMethod:@"POST"];
  
  // Send the request
  NSURLResponse *response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  // Return to previous view
  [[self navigationController] popViewControllerAnimated:YES];
}


@end

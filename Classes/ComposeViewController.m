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
  
  // Create the request
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  [request setURL:[NSURL URLWithString:urlString]];
  
  // Set request body and HTTP method
  NSString *usernameString = [[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"] autorelease];
  NSString *passwordString = [[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"] autorelease];
  
  NSString *postBody = [NSString stringWithFormat:@"body=%@&username=%@&password=%@", postContent.text, usernameString, passwordString];
  [request setHTTPBody:[postBody dataUsingEncoding: NSASCIIStringEncoding]];
  [request setHTTPMethod:@"POST"];
  
  // Send the request
  NSHTTPURLResponse *response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  int statusCode = (int)[response statusCode];
  if (statusCode == 201) {
    // Success! Return to previous view
    if (parentPost) {
      DetailViewController *viewController = [[self navigationController].viewControllers objectAtIndex:[[self navigationController].viewControllers count] - 2];
      [viewController refresh:nil];
    } else {
      RootViewController *viewController = [[self navigationController].viewControllers objectAtIndex:[[self navigationController].viewControllers count] - 2];
      [viewController refresh:nil];
    }
    
    
    [[self navigationController] popViewControllerAnimated:YES];
    
  } else if (statusCode == 403) {
    // Authentication Failure, display alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed"
                                                    message:@"It appears you credentials aren't right.  Go your device settings and set your username and password for the \"LatestChatty\" application."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
  } else {
    // Something unexpected happened, display alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unexpected Error"
                                                    message:@"Something has gone wrong.  Sorry for the inconvience, but this can't be posted right now."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
  }

}


@end

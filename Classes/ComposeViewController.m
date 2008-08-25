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
  NSDictionary *tagLookup = [NSDictionary dictionaryWithObjectsAndKeys:
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
                              nil];
  
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

- (IBAction)insert:(id)sender{
  UIActionSheet *dialog = [[UIActionSheet alloc] initWithTitle:@"Insert"
                                                      delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                             otherButtonTitles:@"Picture From Camera", @"Picture From Library", @"Paste", nil];
	dialog.actionSheetStyle = UIBarStyleBlackTranslucent;
	dialog.destructiveButtonIndex = -1;
	[dialog showInView:self.view];
	[dialog release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:
      //post image from camera. UIImagePickerControllerSourceTypeCamera
      if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self postImage:UIImagePickerControllerSourceTypeCamera];  
      } else {
        [LatestChattyAppDelegate showErrorAlertNamed:@"No Camera"];
      }
      break;
    case 1:
      //post image from library. UIImagePickerControllerSourceTypePhotoLibrary
      if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self postImage:UIImagePickerControllerSourceTypePhotoLibrary];
      } else {
        [LatestChattyAppDelegate showErrorAlertNamed:@"Empty Photo Library"];
      }
      
      break;
    case 2:
      //Paste from OpenClip
      [self paste:nil];
      break;
  }
}

- (void)postImage:(UIImagePickerControllerSourceType)sourceType{
  // Set up the image picker controller and add it to the view
  imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.delegate = self;
  [imagePickerController viewWillAppear:YES];
  imagePickerController.sourceType = sourceType;
  [self presentModalViewController:imagePickerController animated:YES];  
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)chosenImage editingInfo:(NSDictionary *)editingInfo {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  
  NSLog(@"User picked an image.");
  [picker dismissModalViewControllerAnimated:YES];
    
  // Upload image
  Image *image = [[Image alloc] initWithImage:chosenImage];
  NSString *imageURL = [image post];
  [image release];
  
  // Success! Return to previous view
  if (imageURL != nil) {
    NSLog(@"Got a good response!\nURL: %@", imageURL);
    postContent.text = [[postContent text] stringByAppendingString:imageURL];
  } else {
    NSLog(@"Didn't get a good response.");
  }
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  NSLog(@"User cancelled and didn't pick an image.");
  [picker dismissModalViewControllerAnimated:YES];
}

- (void)sendPostConfirmed {
  // Create the request
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  [request setURL:[NSURL URLWithString:@"http://www.shacknews.com/extras/post_laryn_iphone.x"]];
  
  // Set request body and HTTP method
  NSString *usernameString = [LatestChattyAppDelegate urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]];
  NSString *passwordString = [LatestChattyAppDelegate urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"]];
  NSString *bodyString     = [LatestChattyAppDelegate urlEscape:postContent.text];
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

- (IBAction)paste:(id)sender {
  ZWClipboardItem *item = [[ZWClipboard sharedClipboard] pasteLatestWithMimeType:@"text/plain" error:NULL];
	NSString *pasteText = [[[NSString alloc] initWithData:item.data encoding:NSUTF8StringEncoding] autorelease];
  
  postContent.text = [[postContent text] stringByAppendingString:pasteText];
  [postContent becomeFirstResponder];
  [postContent setSelectedRange:NSMakeRange([postContent.text length], 0)];
}

@end

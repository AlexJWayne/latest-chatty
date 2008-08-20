//
//  ComposeViewController.m
//  LatestChatty
//
//  Created by Alex Wayne on 8/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ComposeViewController.h"
#import "NSStringAdditions.h"

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

- (IBAction)attachImage:(id)sender{
  // Set up the image picker controller and add it to the view
  imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.delegate = self;
  [imagePickerController viewWillAppear:YES];
  //Eventually will add an action sheet here allowing you to pick whether you get the source from the camera or from the library.
  //imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
  
  NSLog(@"User picked an image.");
  [picker dismissModalViewControllerAnimated:YES];
  [[picker view] setHidden:YES];
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[Feed urlStringWithPath:@"images.xml"]]] autorelease];
  [request setHTTPMethod:@"POST"];
  //Think I'll want to use this for images larger than 800 or 1024 pixels or something, since Base64 encoding makes the data a lot larger.
  //NSData *imageData = [self shrinkImageByHalfAndJPEG:image];
  NSData *imageData = UIImagePNGRepresentation(image);
  //NSData *imageData = UIImageJPEGRepresentation(image, .85);
  NSString *imageBase64Data = [self urlEscape:[NSString base64StringFromData:imageData length:[imageData length]]];
  //I want to rewrite this in a function soon too, so we can call it anywhere and get a url encoded string back for username/password AND prompt them for it if it's not in the settings.
  //Sucks ass to type up a post and have forgotten to set your U/P, have to exit and come back to enter it, blah blah.
  NSString *usernameString = [self urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]];
  NSString *passwordString = [self urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"]];
  NSString *postBody = [NSString stringWithFormat:@"username=%@&password=%@&filename=iPhoneUpload.png&image=%@", usernameString, passwordString, imageBase64Data];
  //[imageData release];
  //[imageBase64Data release];
  [request setHTTPBody:[postBody dataUsingEncoding:NSASCIIStringEncoding]];
  
  //NSLog([NSString stringWithFormat:@"Post Body:\r\n%@", postBody]);
  
  // Send the request
  NSHTTPURLResponse *response = nil;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  int statusCode = (int)[response statusCode];
  
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  NSLog(responseString);
  NSLog(@"status: %d", statusCode);

  // Success! Return to previous view
  if (statusCode == 201) {
    NSLog(@"Got a good response!");
    NSString *filename = @"";
    
    //Parse new filename from response.
    //There's a comment that has it in the data, we'll use this for now.
    //<!-- filename: file_hre1vo65wybn41borox4.png -->
    NSRange filenameRangeStart = [responseString rangeOfString:@"<success>"];
    if (filenameRangeStart.location != NSNotFound) {
      int startLocation = filenameRangeStart.location + filenameRangeStart.length;
      NSRange filenameRangeEnd = [responseString rangeOfString:@"</success>" options:NSCaseInsensitiveSearch range:NSMakeRange(startLocation, [responseString length] - startLocation)];
      
      if (filenameRangeEnd.location != NSNotFound) {      
        filename = [responseString substringWithRange:NSMakeRange(startLocation, filenameRangeEnd.location - startLocation)];
      }  
    }
    
    if ([filename length] > 0) {
      postContent.text = [[postContent text] stringByAppendingString:[NSString stringWithFormat:@"http://www.shackpics.com/viewer.x?file=%@", filename]];
    }
  }
  else {
    NSLog(@"Didn't get a good response.");
  }
}

- (NSData*)shrinkImageByHalfAndJPEG:(UIImage *)picture {
  UIImage *retImage = picture;
  
  if ((picture.size.width > 800) || (picture.size.height > 800)) {
    CGImageRef imageRef = [picture CGImage];
    size_t newHeight = picture.size.height *.5;
    size_t newWidth = picture.size.width * .5;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, newWidth, newHeight, CGImageGetBitsPerComponent(imageRef), newWidth * 4, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
    CGContextDrawImage( bitmap, CGRectMake(0,0,newWidth,newHeight), imageRef );
    CGContextRelease( bitmap );
    retImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease( imageRef );
  }
  return UIImageJPEGRepresentation(retImage, .85);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  NSLog(@"User cancelled and didn't pick an image.");
  [picker dismissModalViewControllerAnimated:YES];
  [[picker view] setHidden:YES];
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

- (IBAction)paste:(id)sender {
  ZWClipboardItem *item = [[ZWClipboard sharedClipboard] pasteLatestWithMimeType:@"text/plain" error:NULL];
	NSString *pasteText = [[[NSString alloc] initWithData:item.data encoding:NSUTF8StringEncoding] autorelease];
  
  postContent.text = [[postContent text] stringByAppendingString:pasteText];
  [postContent becomeFirstResponder];
  [postContent setSelectedRange:NSMakeRange([postContent.text length], 0)];
}

@end

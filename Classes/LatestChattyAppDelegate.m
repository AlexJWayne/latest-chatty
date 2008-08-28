//
//  LatestChattyAppDelegate.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/31/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "LatestChattyAppDelegate.h"
#import "ChattyViewController.h"


@implementation LatestChattyAppDelegate

@synthesize window;
@synthesize navigationController;


- (id)init {
	if (self = [super init]) {
		//
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
  // Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


// Todo refactor this to be more DRY
+ (void)showErrorAlertNamed:(NSString *)name {
  NSLog(@"Showing Error named: %@", name);
  
  UIAlertView *alert = [UIAlertView alloc];
  
  if ([name isEqualToString:@"Authentication Failed"]) {
    [alert initWithTitle:name
                 message:@"It appears you credentials aren't right. Go your device settings and set your username and password for the \"LatestChatty\" application."
                delegate:nil
       cancelButtonTitle:@"OK"
       otherButtonTitles:nil];
    
  } else if ([name isEqualToString:@"Post Rate Limited"]) {
    [alert initWithTitle:name
                 message:@"Whoa, hands off that post button. The server says you need to relax for a few minutes."
                delegate:nil
       cancelButtonTitle:@"OK"
       otherButtonTitles:nil];
    
  } else if ([name isEqualToString:@"Post too Short"]) {
    [alert initWithTitle:name
                 message:@"Any post less than 5 characters can't be worth reading, can it?"
                delegate:nil
       cancelButtonTitle:@"OK"
       otherButtonTitles:nil];
    
  } else if ([name isEqualToString:@"No Camera"]) {
    [alert initWithTitle:name
                 message:@"Sorry, I won't be able to take a picture. Your device does not have a camera."
                delegate:nil
       cancelButtonTitle:@"OK"
       otherButtonTitles:nil];
    
  } else if ([name isEqualToString:@"Empty Photo Library"]) {
    [alert initWithTitle:name
                 message:@"You have no photos in library. How am I supposed to post from an empty gallery, huh?"
                delegate:nil
       cancelButtonTitle:@"OK"
       otherButtonTitles:nil];
    
  } else if ([name isEqualToString:@"Banned"]) {
    [alert initWithTitle:name
                 message:@"You have been banned from posting."
                delegate:nil
       cancelButtonTitle:@"OK"
       otherButtonTitles:nil];
  
  } else {
    [alert initWithTitle:@"Unexpected Error"
                 message:@"Something has gone terribly wrong. Sorry for the inconvience, but this can't be posted right now."
                delegate:nil
       cancelButtonTitle:@"OK"
       otherButtonTitles:nil];
  }
  
  [alert show];
  [alert release];
}

+ (NSString *)urlEscape:(NSString *)string {
  return (NSString *)CFURLCreateStringByAddingPercentEscapes(
                      NULL,
                      (CFStringRef)string,
                      NULL,
                      (CFStringRef)@";/?:@&=+$,",
                      kCFStringEncodingUTF8);
}


@end

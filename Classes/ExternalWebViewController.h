//
//  ExternalWebViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsPost.h"
#import "ChattyViewController.h"

@interface ExternalWebViewController : UIViewController {
	IBOutlet UIWebView *webView;
	IBOutlet UIBarButtonItem* chatButton;
	IBOutlet UIBarButtonItem* dragonDropButton;
	NSMutableURLRequest *initialRequest;
	NewsPost* thePost;
	//ChattyViewController* chattyView;
	id chattyView;
	BOOL exitOnFinish;
}

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithNewsPost:(NewsPost*)post;
- (IBAction)openInSafari:(id)sender;
- (IBAction)dragonDrop:(id)sender;
- (IBAction)chat:(id)sender;
- (void)backButton:(id)sender;
- (void)sleepHack;

@end

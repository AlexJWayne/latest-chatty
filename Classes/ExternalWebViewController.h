//
//  ExternalWebViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExternalWebViewController : UIViewController {
  IBOutlet UIWebView *webView;
  
  NSMutableURLRequest *initialRequest;
}

- (id)initWithRequest:(NSURLRequest *)request;

- (IBAction)openInSafari:(id)sender;
- (IBAction)dragonDrop:(id)sender;


@end

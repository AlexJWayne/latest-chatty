//
//  ExternalWebViewController.m
//  LatestChatty
//
//  Created by Alex Wayne on 8/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ExternalWebViewController.h"


@implementation ExternalWebViewController

- (id)init {
	if (self = [self initWithNibName:@"ExternalWebViewController" bundle:nil]) {
		self.title = @"Web";
	}
	return self;
}

- (id)initWithRequest:(NSURLRequest *)request {
  [self init];
  initialRequest = [request retain];
  return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */



- (void)viewDidLoad {
  [webView loadRequest:initialRequest];
  [initialRequest release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [webView release];
	[super dealloc];
}



- (IBAction)openInSafari:(id)sender {
  [[UIApplication sharedApplication] openURL:[webView.request URL]];
}


@end

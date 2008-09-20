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
	initialRequest = (NSMutableURLRequest *)[request retain];
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 */

- (id)initWithNewsPost:(NewsPost*)post {
	self = [self initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:post.link]]];
	self.title = post.title;
	thePost = post;
	return self;
}

- (void)viewDidLoad {
	if (thePost) {
		//remove dragondrop and add chat
		[dragonDropButton setEnabled:NO];
		self.navigationItem.rightBarButtonItem = chatButton;
	}
	[webView loadRequest:initialRequest];
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
	//NSLog(@"DEALLOCEX!");
	NSLog(@"%i", [webView retainCount]);
	[webView release];
	//[webView release];
	[initialRequest release];
	[super dealloc];
}

- (IBAction)chat:(id)sender {
	//need thePost - link
	NSString *link = [thePost link];
	NSArray *comps = [link componentsSeparatedByString:@"/"];
	int story = [[comps objectAtIndex:([comps count]-1)] intValue];
	//if (chattyView) [chattyView release];
	chattyView = [[ChattyViewController alloc] initWithChattyId:story];
	//else [chattyView updateWithStoryId:story];
	[[self navigationController] pushViewController:chattyView animated:YES];
	[chattyView release];
	[chattyView release];
	chattyView = nil;
}

- (IBAction)openInSafari:(id)sender {
	[[UIApplication sharedApplication] openURL:[webView.request URL]];
}

- (IBAction)dragonDrop:(id)sender {
	[initialRequest setValue:@"" forHTTPHeaderField:@"Referer"];
	[webView loadRequest:initialRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[webView stopLoading];
}

@end

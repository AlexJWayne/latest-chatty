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
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButton:)];
	self.navigationItem.leftBarButtonItem = item;
	[item release];
  
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
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//NSLog(@"%i", [webView retainCount]);
	//while( [webView retainCount]>1)[webView release];
	[webView release];
	[initialRequest release];
	[super dealloc];
}

- (IBAction)chat:(id)sender {
	[webView stopLoading];
	[NSThread sleepForTimeInterval:.2];
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

- (void)backButton:(id)sender {
	if (webView.loading){
		//exitOnFinish = YES;
		[webView stopLoading];
	}
	//else [[self navigationController] popViewControllerAnimated:YES];
	[webView loadHTMLString:@"<html></html>" baseURL:nil];
	//[NSThread sleepForTimeInterval:5.0];
	[NSThread detachNewThreadSelector:@selector(sleepHack) toTarget:self withObject:nil];
}

//muahahahahahahahhaha
- (void)sleepHack {
	[NSThread sleepForTimeInterval:2.0];
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[[self navigationController] popViewControllerAnimated:YES];
	[pool release];
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
	NSLog(@"finished!");
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end

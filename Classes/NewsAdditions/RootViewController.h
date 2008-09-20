//
//  RootViewController.h
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSReader.h"
#import "ChattyViewController.h"
#import "LoadingView.h"

@interface RootViewController : UIViewController<RSSDownloadDelegate> {
	RSSReader* theReader;
	NSArray* posts;
	IBOutlet UITableView *tableView;
	IBOutlet UIToolbar* toolBar;
	UIBarButtonItem* refreshButton;
	UIBarButtonItem* stopButton;
	
//	IBOutlet UIBarButtonItem* refreshButton;
//	UIBarButtonItem* temp;
	ExternalWebViewController* postView;
	ChattyViewController* chattyView;
	LoadingView* loadView;
}

-(IBAction) refresh:(id)sender;
-(IBAction) latestChatty:(id)sender;

@end

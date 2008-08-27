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

@interface RootViewController : UIViewController {
	RSSReader* theReader;
	NSArray* posts;
	IBOutlet UITableView *tableView;
	ExternalWebViewController* postView;
	ChattyViewController* chattyView;
}

-(IBAction) refresh:(id)sender;
-(IBAction) latestChatty:(id)sender;

@end

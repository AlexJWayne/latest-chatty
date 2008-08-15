//
//  RootViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/31/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "ComposeViewController.h"
#import "RootPostCellView.h"
#import "Feed.h"
#import "Post.h"

@interface RootViewController : UIViewController {
  Feed *feed;
  
  IBOutlet UITableView *tableView;
}

- (void)feedDidFinishLoading;

- (IBAction)refresh:(id)sender;
- (IBAction)compose:(id)sender;

@end

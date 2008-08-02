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

@interface RootViewController : UITableViewController {
  Feed *feed;
}

- (IBAction)refresh:(id)sender;
- (IBAction)compose:(id)sender;

@end

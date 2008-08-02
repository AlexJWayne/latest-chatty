//
//  DetailViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "Feed.h"
#import "Post.h"

@interface DetailViewController : UIViewController {
  IBOutlet UIWebView *postView;
  IBOutlet UITableView *tableView;
  IBOutlet UIToolbar *toolbarView;
  
  BOOL tableIsVisible;
  int storyId;
  Post *currentRoot;
  Post *currentPost;
  int currentPostIndex;
}

- (id)initWithStoryId:(int)aStoryId rootPost:(Post *)post;
- (void)showCurrentThread;
- (void)showPost:(Post *)post;
- (void)updateViews;

- (IBAction)toggleTable:(id)sender;
- (IBAction)prevReply:(id)sender;
- (IBAction)nextReply:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)reply:(id)sender;

@end


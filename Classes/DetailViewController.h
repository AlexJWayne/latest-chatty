//
//  DetailViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "ExternalWebViewController.h"
#import "Feed.h"
#import "Post.h"
#import "RegexKitLite.h"

@interface DetailViewController : UIViewController <UIActionSheetDelegate> {
  IBOutlet UIWebView *postView;
  IBOutlet UITableView *tableView;
  IBOutlet UIToolbar *toolbarView;
  IBOutlet UIBarButtonItem *refreshButton;
  IBOutlet UIActivityIndicatorView *refreshButtonLoading;
  
  BOOL tableIsVisible;
  int storyId;
  Post *currentRoot;
  Post *currentPost;
  int currentPostIndex;
  BOOL loading;
  BOOL popAfterLoad;
  
  BOOL nextNavigateIsToAThread;
  int  nextThreadPostId;
}

- (id)initWithStoryId:(int)aStoryId rootPost:(Post *)post;
- (void)showCurrentThread;
- (void)showPost:(Post *)post;
- (void)updateViews;

- (IBAction)toggleTable:(id)sender;

- (IBAction)prevReply:(id)sender;
- (IBAction)nextReply:(id)sender;
- (void)showRow:(int)row;
   
- (IBAction)refresh:(id)sender;
- (void)refreshAndPop;

- (IBAction)reply:(id)sender;
- (IBAction)tag:(id)sender;
- (void)tagWithTag:(NSString *)tag;

@end


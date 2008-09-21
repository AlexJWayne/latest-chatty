//
//  ChattyViewController.h
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
#import "LoadingView.h"

@interface ChattyViewController : UIViewController {
	Feed *feed;
	int chatId;
	IBOutlet UITableView *tableView;
	IBOutlet UIToolbar* toolBar;
	UIBarButtonItem* refreshButton;
	UIBarButtonItem* stopButton;
	//for some reason, when loadmore happens it lazily sets the rowOfLoadingCell type
	//so this is a dirty hack that I need to fix later so that's the purpose
	//of this bool
	BOOL loadingNextPage;
	int rowOfLoadingCell;
	
	UIButton* scrollTrigger;
	
	Post* loadingPost;
	LoadingView* loadView;
}

- (void)stopPostFromLoading;
- (void)scrollUp:(id)sender;
- (void)feedDidFinishLoading;
- (id) initWithChattyId:(int)chatIdNum;
- (IBAction)refresh:(id)sender;
- (IBAction)compose:(id)sender;

@end

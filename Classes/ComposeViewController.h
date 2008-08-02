//
//  ComposeViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface ComposeViewController : UIViewController {
  IBOutlet UILabel *parentPreview;
  IBOutlet UITextView *postContent;
  
  Post *parentPost;
  int storyId;
}

- (id)initWithStoryId:(int)aStoryId;
- (id)initWithStoryId:(int)aStoryId parentPost:(Post *)aPost;

- (IBAction)sendPost:(id)sender;

@end

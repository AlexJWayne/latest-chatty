//
//  RootPostCellView.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface RootPostCellView : UITableViewCell {
  Post *post;
  UILabel *username;
  UILabel *timestamp;
  UILabel *preview;
  UILabel *replyCount;
  UILabel *category;
  UIActivityIndicatorView *activityIndicator;
  
  BOOL striped;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initLoadMore;
- (id)initForPost;
- (void)updateWithPost:(Post *)aPost;
- (void)setLoading:(BOOL)isLoading;

@property (readonly) UILabel *preview;
@property (nonatomic) BOOL striped;

@end

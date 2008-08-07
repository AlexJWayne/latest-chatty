//
//  RootPostCellView.m
//  LatestChatty
//
//  Created by Alex Wayne on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RootPostCellView.h"


@implementation RootPostCellView

@synthesize preview;

- (id)init {
  [super initWithFrame:CGRectMake(0, 0, 320, 70)];
  
  // Background view
  UIView *bg = [[UIView alloc] init];
  bg.backgroundColor = [UIColor clearColor];
  self.backgroundView = bg;
  
  return self;
}

- (id)initLoadMore {
  [self init];
    
  // Post preview
  preview = [[UILabel alloc] initWithFrame:CGRectMake(5, 16, 320, 38)];
  preview.backgroundColor = [UIColor clearColor];
  preview.numberOfLines = 1;
  preview.font = [UIFont boldSystemFontOfSize:18];
  preview.textColor = [UIColor colorWithWhite:1.0 alpha:0.4];
  preview.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
  preview.textAlignment = UITextAlignmentCenter;
  preview.text = @"Load More";
  [self.contentView addSubview:preview];
  
  activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicator.frame = CGRectMake(141, 16, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
  [self.contentView addSubview:activityIndicator];
  
  return self;
}

- (id)initWithPost:(Post *)aPost {
  [self init];
  
  post = [aPost retain];
  
  // username label
  username = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 155, 12)];
  username.font = [UIFont systemFontOfSize:10];
  username.textColor = [UIColor colorWithRed:1.0 green:0.73 blue:0 alpha:1.0];
  username.backgroundColor = [UIColor clearColor];
  username.text = post.author;
  [self.contentView addSubview:username];
  
  // timestamp label
  timestamp = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 155, 12)];
  timestamp.font = [UIFont systemFontOfSize:10];
  timestamp.textColor = [UIColor colorWithWhite:0.39 alpha:1.0];
  timestamp.backgroundColor = [UIColor clearColor];
  timestamp.textAlignment = UITextAlignmentRight;
  timestamp.text = post.formattedDate;
  [self.contentView addSubview:timestamp];
  
  // Post preview
  preview = [[UILabel alloc] initWithFrame:CGRectMake(5, 18, 285, 38)];
  preview.backgroundColor = [UIColor clearColor];
  preview.numberOfLines = 2;
  preview.font = [UIFont systemFontOfSize:14];
  preview.minimumFontSize = 14;
  preview.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
  preview.text = post.preview;
  [self.contentView addSubview:preview];
  
  // Loading spinner
  activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  activityIndicator.frame = CGRectMake(295, 25, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
  [self.contentView addSubview:activityIndicator];
  
  // Reply count
  if (post.cachedReplyCount > 0) {
    UILabel *replyCount = [[UILabel alloc] initWithFrame:CGRectMake(5, 52, 310, 20)];
    replyCount.text = [NSString stringWithFormat:@"%d", post.cachedReplyCount];
    replyCount.font = [UIFont systemFontOfSize:11];
    replyCount.textAlignment = UITextAlignmentRight;
    replyCount.opaque = NO;
    replyCount.backgroundColor = [UIColor clearColor];
    replyCount.textColor = [UIColor colorWithWhite:0.39 alpha:1.0];
    [self.contentView addSubview:replyCount];
  }
  
  
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (void)updateStatus {
  if (preview.text == @"Load More") preview.text = @"";
  [activityIndicator startAnimating];
}


- (void)dealloc {
  [post release];
	[super dealloc];
}


@end

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
@synthesize striped;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  [self initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier];
  
  // Background view
  UIView *bg = [[UIView alloc] init];
  bg.backgroundColor = [UIColor clearColor];
  self.backgroundView = bg;
  
  return self;
}

- (id)initLoadMore {
  [self initWithReuseIdentifier:@"loadMoreCell"];
  
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

- (id)initForPost {
  [self initWithReuseIdentifier:@"rootPostCell"];
  
  // username label
  username = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 155, 12)];
  username.backgroundColor = [UIColor clearColor];
  [self.contentView addSubview:username];
  
  // timestamp label
  timestamp = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 155, 12)];
  timestamp.font = [UIFont systemFontOfSize:10];
  timestamp.textColor = [UIColor colorWithWhite:0.39 alpha:1.0];
  timestamp.backgroundColor = [UIColor clearColor];
  timestamp.textAlignment = UITextAlignmentRight;
  [self.contentView addSubview:timestamp];
  
  // Post preview
  preview = [[UILabel alloc] initWithFrame:CGRectMake(5, 18, 285, 38)];
  preview.backgroundColor = [UIColor clearColor];
  preview.numberOfLines = 2;
  preview.font = [UIFont systemFontOfSize:14];
  preview.minimumFontSize = 14;
  preview.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
  [self.contentView addSubview:preview];
  
  // Loading spinner
  activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  activityIndicator.frame = CGRectMake(295, 25, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
  [self.contentView addSubview:activityIndicator];
  
  // Reply count
  replyCount = [[UILabel alloc] initWithFrame:CGRectMake(5, 52, 310, 20)];
  replyCount.font = [UIFont systemFontOfSize:11];
  replyCount.textAlignment = UITextAlignmentRight;
  replyCount.opaque = NO;
  replyCount.backgroundColor = [UIColor clearColor];
  replyCount.textColor = [UIColor colorWithWhite:0.39 alpha:1.0];
  [self.contentView addSubview:replyCount];
  
  // Category
  category = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 12)];
  category.font = [UIFont boldSystemFontOfSize:10];
  category.textAlignment = UITextAlignmentCenter;
  category.opaque = NO;
  category.backgroundColor = [UIColor clearColor];
  category.textColor = [UIColor colorWithWhite:0.39 alpha:1.0];
  [self.contentView addSubview:category];
  
	return self;
}

- (void)updateWithPost:(Post *)aPost {
  post = [aPost retain];
  username.text = post.author;
  timestamp.text = post.formattedDate;
  preview.text = post.preview;
  replyCount.text = [NSString stringWithFormat:@"%d", post.cachedReplyCount];
  
  if ([post.category isEqualToString:@"nws"]) {
    category.text = @"NWS";
    category.textColor = [UIColor redColor];
  } else if ([post.category isEqualToString:@"informative"]) {
    category.text = @"INTERESTING";
    category.textColor = [UIColor colorWithRed:0.02 green:0.65 blue:0.83 alpha:1.0];
  } else {
    category.text = @"";
    category.textColor = [UIColor colorWithWhite:0.39 alpha:1.0];
  }
  
  if ([post.author isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]]) {
    username.textColor = [UIColor colorWithRed:0.0 green:0.75 blue:0.95 alpha:1.0];
    username.font = [UIFont boldSystemFontOfSize:10];
  } else {
    username.textColor = [UIColor colorWithRed:1.0 green:0.73 blue:0.0  alpha:1.0];
    username.font = [UIFont systemFontOfSize:10];
  }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (void)setLoading:(BOOL)isLoading {
  if (isLoading) {
    if (preview.text == @"Load More") {
      preview.text = @"";
    }
    [activityIndicator startAnimating];    
  } else {
    [activityIndicator stopAnimating];
  }
}

- (void)setStriped:(BOOL)isStriped {
  striped = isStriped;
  if (striped) {
    [self.backgroundView setBackgroundColor:[UIColor colorWithWhite:.231 alpha:1.0]];
  } else {
    [self.backgroundView setBackgroundColor:[UIColor colorWithWhite:.196 alpha:1.0]];
  }
}


- (void)dealloc {
  [post release];
	[super dealloc];
}


@end

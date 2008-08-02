//
//  RootPostCellView.m
//  LatestChatty
//
//  Created by Alex Wayne on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RootPostCellView.h"


@implementation RootPostCellView

- (id)initWithPost:(Post *)aPost {
  if (self = [super initWithFrame:CGRectMake(0, 0, 320, 70)]) {
		post = [aPost retain];
    
    // username label
    username = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 155, 12)];
    username.font = [UIFont systemFontOfSize:10];
    username.textColor = [UIColor colorWithRed:1.0 green:0.73 blue:0 alpha:1.0];
    username.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    username.text = post.author;
    [self.contentView addSubview:username];
    
    // timestamp label
    timestamp = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 155, 12)];
    timestamp.font = [UIFont systemFontOfSize:10];
    timestamp.textColor = [UIColor colorWithWhite:0.39 alpha:1.0];
    timestamp.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    timestamp.textAlignment = UITextAlignmentRight;
    timestamp.text = post.date;
    [self.contentView addSubview:timestamp];
    
    // Post preview
    preview = [[UILabel alloc] initWithFrame:CGRectMake(5, 18, 290, 38)];
    preview.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    preview.numberOfLines = 2;
    preview.font = [UIFont systemFontOfSize:14];
    preview.minimumFontSize = 14;
    preview.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    preview.text = post.preview;
    [self.contentView addSubview:preview];
    
    // Added the "There more content if you tap here" accesory view
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
  [post release];
	[super dealloc];
}


@end

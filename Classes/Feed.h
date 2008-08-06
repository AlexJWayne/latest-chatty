//
//  Feed.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import "Post.h"


@interface Feed : NSObject {
  CXMLDocument *xml;
  NSMutableArray *posts;
  int storyId;
  int lastPageLoaded;
  int lastPage;
}

- (id)initWithLatestChatty;
- (id)initWithUrl:(NSString *)url;
- (id)initWithStoryId:(int)aStoryId;
- (void)addPostsInFeedWithUrl:(NSString *)urlString;

- (void)loadNextPage;
- (BOOL)hasMorePages;

- (NSArray *)posts;

@property (readwrite) int storyId;

@end

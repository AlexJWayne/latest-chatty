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
  id delegate;
  
  NSMutableData *partialData;
  CXMLDocument *xml;
  NSMutableArray *posts;
  int storyId;
  int lastPageLoaded;
  int lastPage;
}

+ (NSString *)urlStringWithPath:(NSString *)path;

- (id)initWithLatestChattyAndDelegate:(id)aDelegate;
- (id)initWithUrl:(NSString *)urlString delegate:(id)aDelegate;
- (id)initWithStoryId:(int)aStoryId delegate:(id)aDelegate;
- (void)addPostsInFeedWithUrl:(NSString *)urlString;
- (void)addPostsInFeedWithString:(NSString *)dataString;

- (void)loadNextPage;
- (BOOL)hasMorePages;

- (NSArray *)posts;

@property (readwrite) int storyId;
@property (readonly) int lastPageLoaded;

@end

//
//  Post.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "TouchXML.h"

@interface Post : NSObject {
  id delegate;
  NSMutableData *partialData;
  
  Post *parent;
  NSString *author;
  NSString *preview;
  NSString *body;
  NSString *category;
  NSDate *date;
  int postId;
  NSMutableArray *children;

	NSURLConnection* theConnection;
	
  int depth;
  int cachedReplyCount;
  int recentIndex;
  int newPostCount;
}

- (id)initWithXmlElement:(CXMLElement *)xml parent:(Post *)aParent lastRefreshDict:(NSMutableDictionary *)lastRefresh;
- (BOOL)parseXml:(CXMLElement *)xml lastRefreshDict:(NSMutableDictionary *)lastRefresh;
  
- (id)initWithThreadId:(int)threadId delegate:(id)aDelegate;

- (NSString *)html;
- (int)replyCount;
- (Post *)postAtIndex:(int)index;
- (NSString *)cleanString:(NSString *)string;
- (void) abortLoadIfLoading;
- (int)compare:(Post *)otherPost;
- (void)killChildren;

@property (retain) Post *parent;
@property (retain, nonatomic) NSString *author;
@property (retain, nonatomic) NSString *preview;
@property (retain, nonatomic) NSString *body;
@property (retain, nonatomic) NSString *category;
@property (retain, nonatomic) NSDate *date;
@property (assign, nonatomic) int postId;
@property (retain, nonatomic) NSMutableArray *children;
@property (assign, nonatomic) int depth;
@property (assign, nonatomic) int cachedReplyCount;
@property (assign, nonatomic) int newPostCount;
@property (retain, nonatomic) NSString *formattedDate;
@property (assign, nonatomic) int recentIndex;

@end

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
  Post *parent;
  NSString *author;
  NSString *preview;
  NSString *body;
  NSString *category;
  NSDate *date;
  int postId;
  NSMutableArray *children;
  int depth;
  int cachedReplyCount;
}

- (id)initWithXmlElement:(CXMLElement *)xml parent:(Post *)aParent;
- (id)initWithThreadId:(int)threadId;

- (NSString *)html;
- (int)replyCount;
- (Post *)postAtIndex:(int)index;
- (NSString *)cleanString:(NSString *)string;

@property (readwrite, retain) Post *parent;
@property (readwrite, copy) NSString *author;
@property (readwrite, copy) NSString *preview;
@property (readwrite, copy) NSString *body;
@property (readwrite, copy) NSString *category;
@property (readwrite, copy) NSDate *date;
@property (readwrite) int postId;
@property (readwrite, retain) NSMutableArray *children;
@property (readwrite, assign) int depth;
@property (readwrite, assign) int cachedReplyCount;
@property (readonly) NSString *formattedDate;

@end

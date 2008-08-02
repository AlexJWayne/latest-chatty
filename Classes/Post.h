//
//  Post.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"

@interface Post : NSObject {
  Post *parent;
  NSString *author;
  NSString *preview;
  NSString *body;
  NSString *date;
  NSString *postId;
  NSMutableArray *children;
  int depth;
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
@property (readwrite, copy) NSString *date;
@property (readwrite, copy) NSString *postId;
@property (readwrite, retain) NSMutableArray *children;
@property (readwrite, assign) int depth;

@end

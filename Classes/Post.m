//
//  Post.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Post.h"


@implementation Post

@synthesize parent;
@synthesize author;
@synthesize preview;
@synthesize body;
@synthesize date;
@synthesize postId;
@synthesize children;
@synthesize depth;

- (id)initWithXmlElement:(CXMLElement *)xml parent:(Post *)aParent {
  [super init];
  
  self.parent   = [aParent retain];
  self.author   = [[xml attributeForName:@"author"]  stringValue];
  self.date     = [[xml attributeForName:@"date"]    stringValue];
  self.postId   = [[[xml attributeForName:@"id"]     stringValue] intValue];
  self.preview  = [[xml attributeForName:@"preview"] stringValue];
  self.body     = [[[xml nodesForXPath:@"body"  error:nil] objectAtIndex:0] stringValue];
  self.children = [[NSMutableArray alloc] init];
  
  self.preview  = [self cleanString:self.preview];
  
  if (parent == nil) {
    self.depth = 0;
  } else {
    self.depth = parent.depth + 1;
  }
  
  NSArray *postElements = [xml nodesForXPath:@"comments/comment" error:nil];
  for (CXMLElement *postXml in [postElements objectEnumerator]) {
    [children addObject:[[Post alloc] initWithXmlElement:postXml parent:self]];
  }
  
  return self;
}

- (id)initWithThreadId:(int)threadId {
  NSString *urlString = [NSString stringWithFormat:@"http://latestchatty.beautifulpixel.com/thread/%d.xml", threadId];
  CXMLDocument *xml = [[[CXMLDocument alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]
                                                           options:1
                                                             error:nil] autorelease];
  
  return [self initWithXmlElement:[[xml nodesForXPath:@"comments/comment"  error:nil] objectAtIndex:0] parent:nil];
}


- (void)dealloc {
  [parent release];
  [author release];
  [preview release];
  [body release];
  [date release];
  [children dealloc];
  [super dealloc];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"author: %@, date: %@, body: %@", author, date, body];
}

- (NSString *)html {
  NSString *template = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"post" ofType:@"html"]];
  template = [template stringByReplacingOccurrencesOfString:@"<%= date %>"   withString:date];
  template = [template stringByReplacingOccurrencesOfString:@"<%= author %>" withString:author];
  template = [template stringByReplacingOccurrencesOfString:@"<%= body %>"   withString:body];
  
  return template;
}

- (NSInteger)replyCount {
  NSInteger count = [children count];
  for (Post *post in [children objectEnumerator]) {
    count = count + [post replyCount];
  }
  return count;
}

- (Post *)postAtIndex:(int)index {
  Post *result;
  
  if (index == 0) {
    result = self;
  } else {
    for (Post *post in [children objectEnumerator]) {
      if (index <= [post replyCount]+1) {
        return [post postAtIndex:index - 1];
      } else {
        index = index - [post replyCount] - 1;
      }
    }
  }
  
  return result;
}

- (NSString *)cleanString:(NSString *)string {
  string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
  string = [string stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
  string = [string stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
  
  return string;
}

@end

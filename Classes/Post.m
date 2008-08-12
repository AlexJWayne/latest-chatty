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
@synthesize category;
@synthesize date;
@synthesize postId;
@synthesize children;
@synthesize depth;
@synthesize cachedReplyCount;

- (id)init {
  [super init];
  partialData = [[NSMutableData alloc] init];
  return self;
}

- (id)initWithXmlElement:(CXMLElement *)xml parent:(Post *)aParent {
  [self init];
  self.parent = [aParent retain];
  if ([self parseXml:xml]) {
    return self;
  } else {
    return nil;
  }
}

- (BOOL)parseXml:(CXMLElement *)xml {
  // Set basic attributes
  self.author   = [[xml attributeForName:@"author"]  stringValue];
  self.date     = [NSDate dateWithNaturalLanguageString:[[xml attributeForName:@"date"] stringValue]];
  self.postId   = [[[xml attributeForName:@"id"]     stringValue] intValue];
  self.preview  = [[xml attributeForName:@"preview"] stringValue];
  self.body     = [[[xml nodesForXPath:@"body"  error:nil] objectAtIndex:0] stringValue];
  self.category = [[xml attributeForName:@"category"] stringValue];
  self.preview  = [self cleanString:self.preview];
  self.cachedReplyCount = [[[xml attributeForName:@"reply_count"] stringValue] intValue];
  
  // set depth
  if (parent == nil) {
    self.depth = 0;
  } else {
    self.depth = parent.depth + 1;
  }
  
  // traverse children
  self.children = [[NSMutableArray alloc] init];
  NSArray *postElements = [xml nodesForXPath:@"comments/comment" error:nil];
  for (CXMLElement *postXml in [postElements objectEnumerator]) {
    Post *postObject = [[Post alloc] initWithXmlElement:postXml parent:self];
    if (postObject != nil)
      [children addObject:postObject];
  }
  
  // Filter post
  if ([self.category isEqualToString:@"ontopic"]) {
    return YES;
  } else {
    NSLog(@"filter setting for %@, %d", self.category, (int)[[NSUserDefaults standardUserDefaults] boolForKey:[@"filter_" stringByAppendingString:self.category]]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[@"filter_" stringByAppendingString:self.category]]) {
      return YES;
    } else {
      NSLog(@"denied %@, by %@", self.category, self.author);
      return NO;
    }
  }
}


- (id)initWithThreadId:(int)threadId delegate:(id)aDelegate {
  [self init];
  delegate = aDelegate;
  NSString *urlString = [Feed urlStringWithPath:[NSString stringWithFormat:@"thread/%d.xml", threadId]];
  [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];
  return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [partialData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  CXMLDocument *xml = [[[CXMLDocument alloc] initWithData:partialData options:1 error:nil] autorelease];
  [self parseXml:[[xml nodesForXPath:@"comments/comment" error:nil] objectAtIndex:0]];
  
  [delegate threadDidFinishLoadingThread:self];
  [partialData release];
  partialData = [[NSMutableData alloc] init];
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
  template = [template stringByReplacingOccurrencesOfString:@"<%= date %>"   withString:[self formattedDate]];
  template = [template stringByReplacingOccurrencesOfString:@"<%= author %>" withString:author];
  template = [template stringByReplacingOccurrencesOfString:@"<%= body %>"   withString:body];
  template = [template stringByReplacingOccurrencesOfString:@"<%= postId %>" withString:[[NSString alloc] initWithFormat:@"%i", postId]];

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

- (NSString *)formattedDate {
  return [date descriptionWithCalendarFormat:@"%b %d, %Y %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
}

@end

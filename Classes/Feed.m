//
//  Feed.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (id)initWithUrl:(NSString *)urlString {
  [super init];
  
  // Fetch HTML
  NSError *err=nil;
  xml = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]
                                            options:1
                                              error:&err];
  // Parse response into post objects
  posts = [[NSMutableArray alloc] init];
  NSArray *postElements = [[xml rootElement] nodesForXPath:@"comment" error:nil];
  for (CXMLElement *postXml in [postElements objectEnumerator]) {
    [posts addObject:[[Post alloc] initWithXmlElement:postXml parent:nil]];
  }
  
  return self;
}

- (id)init {
  return [self initWithUrl:@"http://latestchatty.beautifulpixel.com/"];
}

- (id)initWithStoryId:(NSString *)storyId {
  return [self initWithUrl:[NSString stringWithFormat:@"http://latestchatty.beautifulpixel.com/%@.xml", storyId]];
}

- (void)dealloc {
  [xml release];
  [posts release];
  [super dealloc];
}




- (NSString *)description {
  return [NSString stringWithFormat:@"XMLDoc: %@", [xml description]];
}

- (NSArray *)posts {
  return posts;
}

@end

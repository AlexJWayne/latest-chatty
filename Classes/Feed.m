//
//  Feed.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"

@implementation Feed

@synthesize storyId;

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
  
  storyId = (int)[[[xml rootElement] attributeForName:@"story_id"] stringValue];
  
  return self;
}

- (id)init {
  return [self initWithUrl:@"http://latestchatty.beautifulpixel.com/"];
}

- (id)initWithStoryId:(NSString *)aStoryId {
  return [self initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://latestchatty.beautifulpixel.com/%@.xml", storyId]]];
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

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

// Designated Initializer.
- (id)init {
  [super init];
  posts = [[NSMutableArray alloc] init];
  return self;
}

// Init with an XML feed at this URL
- (id)initWithUrl:(NSString *)urlString {
  [self init];
  [self addPostsInFeedWithUrl:urlString];
  return self;
}


// Use the default feed that just includes the latest chatty.
- (id)initWithLatestChatty {
  return [self initWithUrl:@"http://latestchatty.beautifulpixel.com/"];
}

// Get a feed for a specific storyId
- (id)initWithStoryId:(int)aStoryId {
  return [self initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://latestchatty.beautifulpixel.com/%d.xml", storyId]]];
}


- (void)addPostsInFeedWithUrl:(NSString *)urlString {
  // Fetch XML
  NSError *err=nil;
  xml = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]
                                            options:1
                                              error:&err];
  // Parse response into post objects
  NSArray *postElements = [[xml rootElement] nodesForXPath:@"comment" error:nil];
  for (CXMLElement *postXml in [postElements objectEnumerator]) {
    [posts addObject:[[Post alloc] initWithXmlElement:postXml parent:nil]];
  }
  
  storyId         = [[[[xml rootElement] attributeForName:@"story_id"]  stringValue] intValue];
  lastPageLoaded  = [[[[xml rootElement] attributeForName:@"page"]      stringValue] intValue];
  lastPage        = [[[[xml rootElement] attributeForName:@"last_page"] stringValue] intValue];  
}


// Load the next page of posts.
- (void)loadNextPage {
  if (lastPageLoaded < lastPage) {
    lastPageLoaded++;
    [self addPostsInFeedWithUrl:[NSString stringWithFormat:@"http://latestchatty.beautifulpixel.com/%d.%d.xml", storyId, lastPageLoaded]];
  }
}

// Return tue if there are more pages to display
- (BOOL)hasMorePages {
  return lastPageLoaded < lastPage;
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

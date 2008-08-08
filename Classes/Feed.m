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
@synthesize lastPageLoaded;

+ (NSString *)urlStringWithPath:(NSString *)path {
  NSString *prefix = [[NSUserDefaults standardUserDefaults] stringForKey:@"api_service"];
  if (prefix == nil) prefix = @"http://ws.shackchatty.com/";
  return [prefix stringByAppendingString:path];
}



// Designated Initializer.
- (id)init {
  [super init];
  posts = [[NSMutableArray alloc] init];
  partialData = [[NSMutableData alloc] init];
  return self;
}

// Init with an XML feed at this URL
- (id)initWithUrl:(NSString *)urlString delegate:(id)aDelegate {
  [self init];
  delegate = [aDelegate retain];
  [self addPostsInFeedWithUrl:urlString];
  return self;
}

// Use the default feed that just includes the latest chatty.
- (id)initWithLatestChattyAndDelegate:(id)aDelegate {
  return [self initWithUrl:[Feed urlStringWithPath:@"index.xml"] delegate:aDelegate];
}

// Get a feed for a specific storyId
- (id)initWithStoryId:(int)aStoryId delegate:(id)aDelegate {
  return [self initWithUrl:[Feed urlStringWithPath:[NSString stringWithFormat:@"%d.xml", storyId]] delegate:aDelegate];
}

- (void)addPostsInFeedWithUrl:(NSString *)urlString {
  [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [partialData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self addPostsInFeedWithString:[[NSString alloc] initWithData:partialData encoding:NSASCIIStringEncoding]];
  [delegate feedDidFinishLoading];
  [partialData release];
  partialData = [[NSMutableData alloc] init];
}

- (void)addPostsInFeedWithString:(NSString *)dataString {
  // Parse XML
  NSError *err=nil;
  xml = [[CXMLDocument alloc] initWithXMLString:dataString options:1 error:&err];
  
  // Parse response into post objects
  NSArray *postElements = [[xml rootElement] nodesForXPath:@"comment" error:nil];
  for (CXMLElement *postXml in [postElements objectEnumerator]) {
    Post *postObject = [[Post alloc] initWithXmlElement:postXml parent:nil];
    if (postObject != nil)
      [posts addObject:postObject];
  }
  
  storyId         = [[[[xml rootElement] attributeForName:@"story_id"]  stringValue] intValue];
  lastPageLoaded  = [[[[xml rootElement] attributeForName:@"page"]      stringValue] intValue];
  lastPage        = [[[[xml rootElement] attributeForName:@"last_page"] stringValue] intValue];  
}


// Load the next page of posts.
- (void)loadNextPage {
  if (lastPageLoaded < lastPage) {
    lastPageLoaded++;
    [self addPostsInFeedWithUrl:[Feed urlStringWithPath:[NSString stringWithFormat:@"%d.%d.xml", storyId, lastPageLoaded]]];
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

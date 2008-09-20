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
@synthesize recentIndex;
@synthesize hasNewPosts;
@synthesize youParticipated;

- (id)init {
	[super init];
	partialData = [[NSMutableData alloc] init];
	return self;
}

- (id)initWithXmlElement:(CXMLElement *)xml parent:(Post *)aParent lastRefreshDict:(NSMutableDictionary *)lastRefresh {
	[self init];
	self.parent = [aParent retain];
	if ([self parseXml:xml lastRefreshDict:lastRefresh]) {
		return self;
	} else {
		return nil;
	}
}

- (BOOL)parseXml:(CXMLElement *)xml lastRefreshDict:(NSMutableDictionary *)lastRefresh {
	// Set basic attributes
	self.author   = [[xml attributeForName:@"author"]  stringValue];
	self.date     = [NSDate dateWithNaturalLanguageString:[[xml attributeForName:@"date"] stringValue]];
	self.postId   = [[[xml attributeForName:@"id"]     stringValue] intValue];
	self.preview  = [[xml attributeForName:@"preview"] stringValue];
	self.body     = [[[xml nodesForXPath:@"body"  error:nil] objectAtIndex:0] stringValue];
	self.category = [[xml attributeForName:@"category"] stringValue];
	self.preview  = [self cleanString:self.preview];
	self.cachedReplyCount = [[[xml attributeForName:@"reply_count"] stringValue] intValue];
  self.hasNewPosts = NO;
  
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
		Post *postObject = [[Post alloc] initWithXmlElement:postXml parent:self lastRefreshDict:nil];
		if (postObject != nil){
			[children addObject:postObject];
      if (parent == nil){ 
        self.youParticipated = ([postObject.author rangeOfString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]].location != NSNotFound); 
      }
			[postObject release];
		}
	}
  /*
  NSArray *postElements = [xml nodesForXPath:@"comments//comment" error:nil];
	for (CXMLElement *postXml in [postElements objectEnumerator]) {
		Post *postObject = [[Post alloc] initWithXmlElement:postXml parent:self lastRefreshDict:nil];
		if (postObject != nil){
			[children addObject:postObject];
      if (parent == nil){ 
        self.youParticipated = ([postObject.author rangeOfString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]].location != NSNotFound); 
      }
			[postObject release];
		}
	}
  */
  if((parent == nil) && (lastRefresh != nil)) {
    NSString* postID = [NSString stringWithFormat:@"%d", self.postId];
    NSNumber* previousPostCount = [lastRefresh valueForKey:postID];
    // If we haven't seen the post before, or if the count of children is more than the last time we saw it, mark it as having new posts.
    hasNewPosts = (previousPostCount == nil) || ([previousPostCount intValue] < self.cachedReplyCount);
    [lastRefresh setValue:[NSNumber numberWithInt:self.cachedReplyCount] forKey:postID];
  }
	
	// get the recent sort index
	if (parent == nil) {
		int i;
		NSMutableArray *sortedByRecent = [[NSMutableArray alloc] initWithObjects:self, nil];
		
		for (i = 0; i <= cachedReplyCount; i++) {
			[sortedByRecent addObject:[self postAtIndex:i]];
		}
		[sortedByRecent sortUsingSelector:@selector(compare:)];
		
		for (i = 0; i <= cachedReplyCount; i++) {
			[[sortedByRecent objectAtIndex:i] setRecentIndex:i];
		}
		
		[sortedByRecent release];
	}
	
	// Filter post
	if ([self.category isEqualToString:@"ontopic"]) {
		return YES;
	} else {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:[@"filter_" stringByAppendingString:self.category]]) {
			return YES;
		} else {
			return NO;
		}
	}
}


- (id)initWithThreadId:(int)threadId delegate:(id)aDelegate {
	[self init];
	delegate = aDelegate;
	NSString *urlString = [Feed urlStringWithPath:[NSString stringWithFormat:@"thread/%d.xml", threadId]];
	theConnection = [[NSURLConnection alloc] initWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self startImmediately:YES];
	//[NSURLConnection connectionWithRequest:] delegate:self];
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[partialData appendData:data];
}

- (void) abortLoadIfLoading
{
	[theConnection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	CXMLDocument *xml = [[[CXMLDocument alloc] initWithData:partialData options:1 error:nil] autorelease];
	[self parseXml:[[xml nodesForXPath:@"comments/comment" error:nil] objectAtIndex:0] lastRefreshDict:nil];
	
	[delegate didFinishLoadingThread:self];
	//[partialData release];
	//partialData = [[NSMutableData alloc] init];
}



- (void)dealloc {
	if( parent ) [parent release];
	if( author )[author release];
	if( preview )[preview release];
	if( body )[body release];
	if( date )[date release];
	if( children )[children dealloc];
	if( partialData )[partialData release];
	if( category )[category release];
	[theConnection release];
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
	template = [template stringByReplacingOccurrencesOfString:@"<%= postId %>" withString:[[[NSString alloc] initWithFormat:@"%i", postId]autorelease]];
	
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

- (int)compare:(Post *)otherPost {
	if (postId < otherPost.postId) {
		return NSOrderedDescending;
	} else {
		return NSOrderedAscending;
	}
}

@end

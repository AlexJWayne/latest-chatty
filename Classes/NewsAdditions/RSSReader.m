//
//  RSSReader.m
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RSSReader.h"


@implementation RSSReader

NSString* shackURL = @"http://feed.shacknews.com/shackfeed.xml";

- (id)initWithDelegate:(id)nDelegate {
	NSURLRequest* chRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:shackURL] cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
	[NSURLConnection connectionWithRequest:chRequest delegate:self];
	
	//feed = [[CXMLDocument alloc] initWithData:response options:0 error:nil];
	delegate = nDelegate;
	[super init];
	return self;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if(!partialData) partialData = [[NSMutableData alloc] init];
	[partialData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	feed = [[CXMLDocument alloc] initWithData:partialData options:0 error:nil];
	[delegate dataReady];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}
- (NSArray*)getNewsPosts {
	//before we do anything let's release the data
	if (newsPosts != nil) [newsPosts release];
	newsPosts = [[NSMutableArray alloc] init];
	
	CXMLElement* root = [feed rootElement];
	//NSLog(@"root:%@, childCount: %i", [root XMLString], [root childCount]);
	NSArray* items = [root elementsForName:@"item"];
	int i,j;
	NewsPost* post;
	if ([items count] > 0){
		for (i = 0; i < [items count]; i++) {
			CXMLElement* parent = [items objectAtIndex:i];
			post = [[NewsPost alloc] init];
			post.link = [[(CXMLElement*)parent attributeForName:(@"about")] stringValue];
			NSArray* children = [parent children];
			for(j = 0; j < [children count]; j++) {
				CXMLNode* temp = [children objectAtIndex:j];
				if ([[temp name] isEqualToString:@"title"]) {
					post.title = [temp stringValue];
				}
				else if ([[temp name] isEqualToString:@"description"]) {
					post.description = [temp stringValue];
				}
				else if ([[temp name] isEqualToString:@"date"]) {
					NSString *dateString = [[[temp stringValue] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@"-06:00" withString:@":00 -0600"];
					NSDate *date = [NSDate dateWithString:dateString];
					NSLog(dateString);
					post.date = [date descriptionWithCalendarFormat:@"%b %d, %Y %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
				}
			}
			[newsPosts addObject:post];
			[post release];
		}
	}
	return newsPosts;
}
-(void) dealloc
{
	[feed release];
	if( partialData ) [partialData release];
	if(newsPosts) [newsPosts release];
	[super dealloc];
}
@end

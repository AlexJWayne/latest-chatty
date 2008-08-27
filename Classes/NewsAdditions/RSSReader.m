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
-(id)init
{	
	NSURLRequest* chRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:shackURL] cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
	NSError* theError;
	NSData* response = [NSURLConnection sendSynchronousRequest:chRequest returningResponse:nil error:&theError];
	feed = [[CXMLDocument alloc] initWithData:response options:0 error:nil];
	[super init];
	return self;
}

-(NSArray*)getNewsPosts
{
	//before we do anything let's release the data
	if(newsPosts != nil ){
		[newsPosts release];
	}
	newsPosts = [[NSMutableArray alloc] init];
	
	
	CXMLElement* root = [feed rootElement];
	//NSLog(@"root:%@, childCount: %i", [root XMLString], [root childCount]);
	NSArray* items = [root elementsForName:@"item"];
	int i,j;
	NewsPost* post;
	if( [items count] > 0 ){
		for( i = 0; i < [items count]; i++ ){
			CXMLElement* parent = [items objectAtIndex:i];
			post = [[NewsPost alloc] init];
			post.link=[[(CXMLElement*)parent attributeForName:(@"about")] stringValue];
			NSArray* children = [parent children];
			for( j = 0; j < [children count]; j++ ){
				CXMLNode* temp = [children objectAtIndex:j];
				if( [[temp name] isEqualToString:@"title"] ){
					post.title = [temp stringValue];
				}
				else if( [[temp name] isEqualToString:@"description"] ){
					post.description = [temp stringValue];
				}
				else if( [[temp name] isEqualToString:@"date"] ){
					NSDateFormatter* format = [[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%dT%H:%M%z" allowNaturalLanguage:NO];
					NSDate* date = [format dateFromString:[temp stringValue]];
					[format release];
					format = [[NSDateFormatter alloc] initWithDateFormat:@"%b %d, %Y %I:%M %p" allowNaturalLanguage:NO];
					//NSLog( @"%f", [date timeIntervalSince1970]);
					//NSLog(@"%@", [format stringFromDate:date] );
					post.date = [format stringFromDate:date];
					[format release];
				}
			}
			[newsPosts addObject:post];
			[post release];
			 }
	}
	//items = [root nodesForXPath:@"RDF/item" error:nil];
	return newsPosts;
}
@end

//
//  NewsPost.m
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NewsPost.h"

@implementation NewsPost
@synthesize link;
@synthesize title;
@synthesize description;
@synthesize date;
-(void) dealloc
{
	[link release];
	[title release];
	[description release];
	[date release];
	[super dealloc];
}
@end

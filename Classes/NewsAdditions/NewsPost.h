//
//  NewsPost.h
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface NewsPost : NSObject {
	NSString* link;
	NSString* title;
	NSString* description;
	NSString* date;
}
@property (copy) NSString* link;
@property (copy) NSString* title;
@property (copy) NSString* description;
@property (copy) NSString* date;
@end

//
//  RSSReader.h
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TouchXML.h"
#import "NewsPost.h"
#import "JFNewsPostCell.h"

@interface RSSReader : NSObject {
	CXMLDocument *feed;
	NSMutableArray *newsPosts;
}

-(NSArray*)getNewsPosts;

@end

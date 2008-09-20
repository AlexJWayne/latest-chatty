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
@protocol RSSDownloadDelegate
-(void)dataReady;
@end

@interface RSSReader : NSObject {
	CXMLDocument *feed;
	NSMutableArray *newsPosts;
	NSMutableData* partialData;
	id delegate;
	NSURLConnection* conn;
}

-(NSArray*)getNewsPosts;
-(id)initWithDelegate:(id)nDelegate;
-(void)stopLoading;

@end

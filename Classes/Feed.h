//
//  Feed.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import "Post.h"


@interface Feed : NSObject {
  CXMLDocument *xml;
  NSMutableArray *posts;
}

- (id)initWithUrl:(NSString *)url;
- (id)initWithStoryId:(NSString *)storyId;
- (NSArray *)posts;

@end

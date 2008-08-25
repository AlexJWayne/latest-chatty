//
//  Image.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatestChattyAppDelegate.h"
#import "Feed.h"

#import "NSStringAdditions.h"

@interface Image : NSObject {
  UIImage *image;
}

- (id)initWithImage:(UIImage *)anImage;
- (NSData *)process;
- (NSString *)base64String;
- (NSString *)post;

@end

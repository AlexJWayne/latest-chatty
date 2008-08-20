//
//  ZWClipboardItem.h
//  Copy
//
//  Created by Zac White on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWClipboardItem : NSObject <NSCoding>{
	NSString *mimeType;
	NSData *data;
	
	NSDictionary *owningApplicationInfo;
	
	NSDate *timeStamp;
}

@property (nonatomic, retain) NSString *mimeType;
@property (nonatomic, retain) NSData *data;

@property (nonatomic, retain) NSDate *timeStamp;

@property (nonatomic, retain) NSDictionary *owningApplicationInfo;



@end

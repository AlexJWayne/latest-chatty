//
//  ZWClipboardItem.m
//  Copy
//
//  Created by Zac White on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ZWClipboardItem.h"

NSString *const ZWClipboardApplicationNameKey = @"ZWClipboardApplicationNameKey";
NSString *const ZWClipboardApplicationBundleIDKey = @"ZWClipboardApplicationBundleIDKey";
NSString *const ZWClipboardApplicationIconDataKey = @"ZWClipboardApplicationIconDataKey";

@implementation ZWClipboardItem

@synthesize mimeType, data, timeStamp, owningApplicationInfo;

- (id)initWithCoder:(NSCoder *)coder {
    if(!(self = [super init])) return nil;
	
    self.mimeType = [coder decodeObjectForKey:@"mimeType"];
    self.data = [coder decodeObjectForKey:@"data"];
    self.timeStamp = [coder decodeObjectForKey:@"timeStamp"];
    self.owningApplicationInfo = [coder decodeObjectForKey:@"owningApplicationInfo"];
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {	
	[coder encodeObject:self.mimeType forKey:@"mimeType"];
	[coder encodeObject:self.data forKey:@"data"];
	[coder encodeObject:self.timeStamp forKey:@"timeStamp"];
	[coder encodeObject:self.owningApplicationInfo forKey:@"owningApplicationInfo"];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@, %@", self.data, self.timeStamp];
}

- (void)dealloc{
	self.mimeType = nil;
	self.data = nil;
	
	self.owningApplicationInfo = nil;
	
	self.timeStamp = nil;
	
	[super dealloc];
}

@end

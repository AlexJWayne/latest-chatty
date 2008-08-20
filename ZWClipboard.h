//
//  ZWClipboard.h
//  CopyPaste
//
//  Created by Zac White on 8/2/08.
//  Copyright 2008 Zac White. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWClipboardItem.h"

@interface ZWClipboard : NSObject {
	//the dictionary of the current clipboard.
	NSMutableArray *localClipboard;
	
	//the external paths to other app clipboards.
	NSMutableArray *externalPaths;
}

+ (ZWClipboard *)sharedClipboard;

- (BOOL)copyData:(NSData *)data withMimeType:(NSString *)mimeType error:(NSError **)err;

- (BOOL)copyClipboardItem:(ZWClipboardItem *)item error:(NSError **)err;

- (ZWClipboardItem *)pasteLatest:(NSError **)err;
- (ZWClipboardItem *)pasteLatestWithMimeType:(NSString *)mimeType error:(NSError **)err;

- (NSArray *)pasteList:(NSError **)err;

- (BOOL)writeToFile:(NSError **)err;

NSComparisonResult PasteSortNewestFirst(ZWClipboardItem *s1, ZWClipboardItem *s2, void *ascending);
- (NSArray *)sortedArray:(NSArray *)inArray ascending:(BOOL)ascending;

@end

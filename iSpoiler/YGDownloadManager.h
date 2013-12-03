//
//  YGDownloadManager.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 03/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoCache.h"
#import "YGNodeItem.h"

typedef void(^completionBlock)();
@interface YGDownloadManager : NSObject
{
    NSOperationQueue * _downloadHTMLQueue;
    NSOperationQueue * _downloadImageQueue;
    completionBlock _stoppingBlock;
    
}
+ (instancetype) sharedInstance;

- (void) setConcurrentOperationsNumber:(NSInteger) number;

- (void) addItemToDownload:(YGNodeItem*) item;
+ (NSString *) randomUserAgent;

- (void) stopDownload;
- (void) setCompletionBlock:(completionBlock) block;
@end

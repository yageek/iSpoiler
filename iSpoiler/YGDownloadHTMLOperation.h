//
//  YGDownloadHTMLOperation.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 24/10/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGNodeItem.h"
#import <Foundation/NSURLConnection.h>
#define YGCacheRecordChanged @"net.yageek.ispoiler.RECORD_CHANGE"

@interface YGDownloadHTMLOperation : NSOperation <NSURLConnectionDelegate>{
    NSPersistentStoreCoordinator * _storeCoordinator;
    YGNodeItem* _nodeItem;
    
    NSURLConnection * _connection;
    NSMutableData * _receivedData;
    BOOL _executing, _finished;
    GeoCache *  _currentCache;
    NSManagedObjectContext * _context;
}

- (id) initWithCacheNodeItem:(YGNodeItem*) node andPersistentStoreCoordinator:(NSPersistentStoreCoordinator*) coordinator;
@end

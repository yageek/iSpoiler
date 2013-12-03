//
//  YGDownloadImageOperation.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 18/11/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGNodeItem.h"
#import "Image.h"

@interface YGDownloadImageOperation : NSOperation{
    NSPersistentStoreCoordinator * _storeCoordinator;
    YGNodeItem* _nodeItem;
    
    NSURLConnection * _connection;
    NSMutableData * _receivedData;
    BOOL _executing, _finished;
    Image *  _currentImage;
    NSManagedObjectContext * _context;
}
- (id) initWithCacheNodeItem:(YGNodeItem*) node andPersistentStoreCoordinator:(NSPersistentStoreCoordinator*) coordinator;

@end

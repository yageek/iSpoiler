//
//  YGGpxStore.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGBlockTypes.h"
#import "YGNodeItem.h"

#define kYGStoreDomain @"net.yageek.iSpoiler.YGStore"


@interface YGGpxStore : NSObject{
    
    NSManagedObjectContext * _managedObjectContext;
    NSManagedObjectModel * _managedObjectModel;
    NSPersistentStoreCoordinator * _store;
    NSOperationQueue * _operationsQueue;
    
    error_block _importCompletionBlock;

    NSArray * _gpxCache;
    BOOL _isCacheInvalide;
    
    YGNodeItem * _rootElement;
}

+ (instancetype) sharedInstance;
- (GeoCache* ) cacheFromID:(NSManagedObjectID*) objID;
@property(readonly,nonatomic) NSManagedObjectContext * managedObjectContext;
@property(readonly,nonatomic) NSPersistentStoreCoordinator * storeCoordinator;
@property(retain,nonatomic) YGNodeItem * rootElement;
@end

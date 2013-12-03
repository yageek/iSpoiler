//
//  YGGpxStore.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore.h"

@implementation YGGpxStore

@synthesize managedObjectContext = _managedObjectContext, storeCoordinator = _store;
@synthesize rootElement = _rootElement;
#pragma mark - Singleton implementation

//To use the object in Interface Builder
- (id) init
{
    return self;
}
- (id) hideInit
{
    if (self = [super init])
    {

        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GpxModel" withExtension:@"momd"];

        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        _store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        [_store addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:_store];

        
        _operationsQueue = [[NSOperationQueue alloc] init];
        _operationsQueue.name = @"Store Operations Queue";
        _operationsQueue.maxConcurrentOperationCount = 1;
        
        _gpxCache  = [[NSMutableArray alloc] init];
        _isCacheInvalide = YES;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *notif)
        {
            [_managedObjectContext mergeChangesFromContextDidSaveNotification:notif];
        }];
        
    }
    return self;
}

+(instancetype) sharedInstance
{
    static YGGpxStore * _store = nil;
    if(!_store)
    {
        _store = [[super allocWithZone:NULL] hideInit];
    }
    return _store;

}
- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}
- (id) retain
{
    return self;
}

- (oneway void) release
{

}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (id) autorelease
{
    return self;
}


- (YGNodeItem* ) rootElement
{
    if(!_rootElement)
    {
        _rootElement = [[YGNodeItem alloc] init];
        
    }
    return _rootElement;
}

- (GeoCache* ) cacheFromID:(NSManagedObjectID*) objID
{
   return (GeoCache*) [self.managedObjectContext existingObjectWithID:objID error:nil];
}
@end

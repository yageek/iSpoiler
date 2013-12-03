//
//  YGParseGPXOperation.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPXFile.h"
#import "GeoCache.h"
#import "YGBlockTypes.h"

@interface YGParseGPXOperation : NSOperation<NSXMLParserDelegate>
{
    NSURL * _gpxURL;
    NSMutableString * _currentValue;
    GPXFile * _currentFile;
    GeoCache* _currentCache;
    NSManagedObjectContext * _managedObjectContext;
    NSPersistentStoreCoordinator * _persistantStoreCoordinator;
    gpx_import_completion_t _completionBlock;

}

- (id) initWithGPXURL:(NSURL*) url WithCoordinator:(NSPersistentStoreCoordinator *) storeCoordinator andCompletionblock:(gpx_import_completion_t) block;
@end

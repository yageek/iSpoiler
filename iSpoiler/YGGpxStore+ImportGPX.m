//
//  YGGpxStore+ImportGPX.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore+ImportGPX.h"
#import "YGParseGPXOperation.h"


@implementation YGGpxStore (ImportGPX)

- (void) addGPXFromURLS:(NSArray*) urls WithCompletionBlock:(error_block)block
{

    _importCompletionBlock = [block copy];
    NSLog(@"Importing files : %@", urls);
    
    NSMutableArray * operations = [NSMutableArray array];
    
    for(NSURL * url in urls)
    {
        YGParseGPXOperation *op = [[YGParseGPXOperation alloc] initWithGPXURL:url WithCoordinator:self.storeCoordinator andCompletionblock:^(NSManagedObjectID * fileID, NSError * error)
        {
             if(!fileID)
             {
                 NSLog(@"Error");
             }
             else
             {
                 GPXFile * file = (GPXFile*) [self.managedObjectContext existingObjectWithID:fileID error:nil];
                 YGNodeItem * node = [YGNodeItem nodeFromGPXFile:file];
                 [self.rootElement.childs addObject:node];
             }
        }
    ];
       [operations addObject:op];
       [op release];
    }
    
    _isCacheInvalide = YES;
    
    NSBlockOperation * updateUI = [NSBlockOperation blockOperationWithBlock:^{
        _importCompletionBlock(nil);
    }];
    
    [updateUI addDependency:[operations lastObject]];
    
    for(NSOperation * op in operations)
    {
        [_operationsQueue addOperation:op];
    }
    
    [[NSOperationQueue mainQueue] addOperation:updateUI];
}
@end

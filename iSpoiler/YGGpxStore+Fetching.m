//
//  YGGpxStore+Fetching.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore+Fetching.h"

@implementation YGGpxStore (Fetching)

- (void) fetchAllGeocaches:(fetch_result_completion_t) block
{
    if(!_isCacheInvalide)
    {
        block([_gpxCache copy],nil);
    }
    else
    {
        [_gpxCache release];
        
        NSError *error = nil;
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        NSEntityDescription * e = [NSEntityDescription entityForName:@"GPXFile" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:e];
        
        NSSortDescriptor * sd  = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        
        [request setSortDescriptors:@[sd]];
        
        NSArray * result = [self.managedObjectContext executeFetchRequest:request error:&error];
        if(!result)
        {
            [NSException raise:@"Could not extract data" format:@"Raison : %@",[error localizedDescription]];
        }
        
        [request release];
        
        if(!error)
        {
            _gpxCache = [result copy];
        }
        block(result,error);
        
    }
}
- (BOOL) isEmpty
{
    return (self.rootElement.childs.count == 0);
}

@end

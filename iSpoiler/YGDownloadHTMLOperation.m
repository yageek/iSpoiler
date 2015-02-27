//
//  YGDownloadHTMLOperation.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 24/10/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//
//http://img.geocaching.com/cache/large/82e01dc0-b8a5-4f6e-ac1d-bed2791b5f4c.jpg
#import "YGDownloadHTMLOperation.h"
#import <RegexKitLite/RegexKitLite.h>
#define IMG_LINK_REGEXP_4 @"<a href=\"(http://img\\.geocaching\\.com/cache/large/[a-zA-Z/]*\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}(?:\\.jpg|\\.png|\\.jpeg|\\.gif))\"(?:\\s*?[a-zA-Z]*=\"[a-zA-z]*\")+>([^<]*)</a>"
#import "Image.h"
#import "GeoCache.h"
#import "YGDownloadManager.h"
#import "YGAppDelegate.h"

@implementation YGDownloadHTMLOperation

- (id) initWithCacheNodeItem:(YGNodeItem*) node andPersistentStoreCoordinator:(NSPersistentStoreCoordinator*) coordinator
{
    if(self = [super init])
    {
        _storeCoordinator = [coordinator retain];
        _nodeItem = [node retain];
        _executing = NO;
        _finished = NO;
    }
    return self;
}

- (void) dealloc
{
    [_storeCoordinator release];
    [_nodeItem release];
    [_connection release];
    [_receivedData release];
    [_currentCache release];
    [_context release];
    [super dealloc];
}
#pragma mark  - Default overriding
- (void) start
{
    if(self.isCancelled)
    {
        [self finishTask];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
   
    _nodeItem.status = YGNodeItemStatusCacheWorking;
    [self main];
}

- (BOOL) isConcurrent
{
    return YES;
}

- (BOOL) isExecuting
{
    return _executing;
}


- (BOOL) isFinished
{
    return _finished;
}

- (void) main
{
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:_storeCoordinator];
    _currentCache = [(GeoCache*)[_context existingObjectWithID:_nodeItem.objectID error:nil] retain];
    

     NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://coord.info/%@",[_currentCache gccode]]];
    
    _receivedData = [[NSMutableData alloc] initWithCapacity:0];
    
    NSMutableURLRequest  * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    [request addValue:[YGDownloadManager randomUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    

    
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_connection start];
    
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _nodeItem.status = YGNodeItemStatusHTMLError;
    _nodeItem.completion = -1.0f;
    
    [self finishTask];
}

#pragma mark - NSURLConnectionDataDelegate
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    if(response.statusCode == 200)
    _receivedData.length = 0;

}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    if(self.isCancelled)
    {
        [_connection cancel];
        [self finishTask];
        return;
    }
    
    [_receivedData appendData:data];
    
    _nodeItem.completion = data.length / _receivedData.length;
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(!_receivedData)
     {
         NSLog(@"No HTML was found :(! Cache : %@",_currentCache.gccode);
         _nodeItem.completion = -1.0f;
         _nodeItem.status = YGNodeItemStatusHTMLError;
         return;
     }
    
    else
    {
         _nodeItem.completion = -1.0f;
        _nodeItem.status = YGNodeItemStatusHTMLFinished;
    }
    if(self.isCancelled)
    {
        [self finishTask];
        return;
    }

    NSString *result = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSArray *temp = [[result componentsMatchedByRegex:IMG_LINK_REGEXP_4] retain];
    
    [result release];
    if(temp.count>0)
    {
        NSLog(@"Images were found for %@",_nodeItem.gccode);
        for(NSString * found in temp)
        {
            @autoreleasepool
            {
                
                if(self.isCancelled)
                {
                    [self finishTask];
                    return;
                }

                NSString *imageUrl = [[found componentsMatchedByRegex:IMG_LINK_REGEXP_4 capture:1] lastObject];
                NSString * imageName = [[found componentsMatchedByRegex:IMG_LINK_REGEXP_4 capture:2] lastObject];
                
                if([[NSApp delegate] downloadSpoilersOnly])
                {
                    if([imageName rangeOfString:@"spoiler" options:NSCaseInsensitiveSearch].location == NSNotFound)
                    {
                        continue;
                    }
                }

                Image* image = [Image insertInManagedObjectContext:_context];
                
                image.url = imageUrl;
                image.name = imageName;

                /*Core Data*/
                [_currentCache addImagesObject:image];
                if(![_context save:nil])
                {
                    NSLog(@"Error by saving");
                    _nodeItem.completion = -1.0f;
                    _nodeItem.status = YGNodeItemStatusHTMLError;
                }

                /*OutlineView*/
                YGNodeItem * item = [YGNodeItem nodeFromImage:image];
                item.status = YGNodeItemStatusHTMLFinished;
                item.parent = _nodeItem;
                [_nodeItem.childs addObject:item];
                
                /* Download */
                [[YGDownloadManager sharedInstance] addItemToDownload:item];
            }
        }
        

    }
    else
    {
        NSLog(@"No images found for :%@",_nodeItem.gccode);
        _nodeItem.completion = -1.0f;
        _nodeItem.status = YGNodeItemStatusNoImageFound;
    }
    
    [temp release];
    [self finishTask];
    
}
- (void) updateStatus
{
    YGNodeItem * parentItem  = _nodeItem.parent;
    BOOL gpxFinished = YES;
    for (YGNodeItem * child in parentItem.childs)
    {
        if(child.status != YGNodeItemStatusCacheFinish && child.status !=YGNodeItemStatusNoImageFound)
        {
            gpxFinished = NO;
            break;
        }
    }
    if(gpxFinished)
    {
        parentItem.status = YGNodeItemStatusGPXFinished;
    }

}
- (void) finishTask
{
   if(self.isCancelled)
   {
       _nodeItem.status = YGNodeItemStatusCancelled;
       _nodeItem.parent.status = YGNodeItemStatusCancelled;
   }
    else
    {
        [self updateStatus];
    }
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];

}
@end

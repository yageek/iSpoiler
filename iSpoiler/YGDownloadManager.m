//
//  YGDownloadManager.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 03/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGDownloadManager.h"
#import "YGDownloadHTMLOperation.h"
#import "YGGpxStore.h"
#import "YGDownloadImageOperation.h"
@implementation YGDownloadManager

//To use the object in Interface Builder
- (id) init
{
    return self;
}
- (id) hideInit
{
    if(self = [super init])
    {
        _downloadHTMLQueue = [[NSOperationQueue alloc] init];
        _downloadHTMLQueue.name = @"net.yageek.ispoiler.HTMLParse";
        
        
        
        _downloadImageQueue = [[NSOperationQueue alloc] init];
        _downloadImageQueue.name = @"net.yageek.ispoiler.imageDownload";
        
        [_downloadImageQueue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:nil];
         [_downloadHTMLQueue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void) setConcurrentOperationsNumber:(NSInteger) number
{
    [_downloadHTMLQueue setMaxConcurrentOperationCount:number];
    [_downloadImageQueue setMaxConcurrentOperationCount:number];
}

- (void) addItemToDownload:(YGNodeItem*) item
{
    YGGpxStore * store = [YGGpxStore sharedInstance];
    
    if(item.type == YGNodeItemTypeCache)
    {
        YGDownloadHTMLOperation * op = [[YGDownloadHTMLOperation alloc] initWithCacheNodeItem:item andPersistentStoreCoordinator:store.storeCoordinator];
        
        
        [_downloadHTMLQueue addOperation:op];
        
        
        [op release];
    }
    else if(item.type == YGNodeItemTypeImage)
    {
        YGDownloadImageOperation * op = [[YGDownloadImageOperation alloc] initWithCacheNodeItem:item andPersistentStoreCoordinator:store.storeCoordinator];
        
        [_downloadImageQueue addOperation:op];
        
        [op release];
    }
}
- (BOOL) isProcessing
{
    return !((_downloadHTMLQueue.operationCount == 0) && (_downloadImageQueue.operationCount == 0));
}
+(instancetype) sharedInstance
{
    static YGDownloadManager * _store = nil;
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
+(NSString * ) randomUserAgent
{
    static NSArray * fakeUserAgentList = nil;
    if(!fakeUserAgentList)
    {
        fakeUserAgentList = [@[
                              @"Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36",
                              @"Mozilla/5.0 (Android; Tablet; rv:19.0) Gecko/19.0 Firefox/19.0",
                              @"Mozilla/5.0 (X11; Linux x86_64; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
                              @"Mozilla/5.0 (BeOS; U; Haiku BePC; en-US; rv:1.8.1.21) Gecko/20090218 Firefox/2.0.0.21",
                              @"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)",
                              @"Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 9.0; en-US)",
                              @"Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; de; rv:1.9.2.28) Gecko/20120308 Camino/2.1.2 (MultiLang) (like Firefox/3.6.28)",
                              @"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 1.1.4322; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; Browzar)",
                              @"Mozilla/5.0 (X11; Linux) KHTML/4.9.1 (like Gecko) Konqueror/4.9",
                              @"Mozilla/5.0 (compatible; Konqueror/3.2; Linux; X11; en_US) (KHTML, like Gecko)",
                              @"Mozilla/5.0 (compatible; Konqueror/3.1-rc5; i686 Linux; 20020621)",
                              @"Mozilla/5.0 (compatible; Konqueror/3.1-rc1; i686 Linux; 20021226)",
                              @"Mozilla/5.0 (compatible; Konqueror/2.1.1; X11)"
                              ] retain];
    }
    NSUInteger randomIndex = arc4random() % [fakeUserAgentList count];
    return [fakeUserAgentList objectAtIndex:randomIndex];
}

- (void) stopDownload
{

    if(_stoppingBlock)
    {
        [self performSelectorInBackground:@selector(callCompletionBlock:) withObject:nil];
    }
    
    [_downloadHTMLQueue cancelAllOperations];

    [_downloadImageQueue cancelAllOperations];
    
}
- (void) setCompletionBlock:(completionBlock) block
{
    id cpy = [block copy];
    [_stoppingBlock release];
    _stoppingBlock = cpy;
}

- (void) callCompletionBlock:(id) __unused object
{
    [_downloadImageQueue waitUntilAllOperationsAreFinished];
    [_downloadHTMLQueue waitUntilAllOperationsAreFinished];
    
    _stoppingBlock();

}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"operationCount"])
    {
        if(_downloadHTMLQueue.operationCount == 0 && _downloadImageQueue.operationCount == 0)
        {
            [self callCompletionBlock:nil];
        }
    }
}


@end

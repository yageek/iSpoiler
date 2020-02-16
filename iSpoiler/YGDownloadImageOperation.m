//
//  YGDownloadImageOperation.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 18/11/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGDownloadImageOperation.h"
#import "GeoCache.h"
#import "YGDownloadManager.h"
#import "YGAppDelegate.h"
#import "YGAppDelegate+Download.h"

@implementation YGDownloadImageOperation
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
    [_context release];

    [_currentImage release];
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
    
    [_nodeItem setValue:@(YGNodeItemStatusImageWorking) forKey:@"status"];
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

    _currentImage = (Image*) [[_context existingObjectWithID:_nodeItem.objectID error:nil] retain];
    
    
    NSURL * url = [NSURL URLWithString:_currentImage.url];
    
    NSMutableURLRequest  * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request addValue:[YGDownloadManager randomUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    _receivedData = [[NSMutableData alloc] initWithCapacity:0];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
    
    [_connection start];
    
    
}

#pragma mark - NSURLConnectionDataDelegate

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _nodeItem.status = YGNodeItemStatusImageError;
    _nodeItem.completion = -1.0f;
    
    [self finishTask];
}

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
    }
    
    [_receivedData appendData:data];
    
    _nodeItem.completion = data.length / _receivedData.length;
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(!_receivedData)
    {
        NSLog(@"No Image was found :( ! URL : %@",_currentImage.url);
        _nodeItem.completion = -1.0f;
        _nodeItem.status = YGNodeItemStatusImageError;
        return;
    }
    
     _nodeItem.status = YGNodeItemStatusImageFinished;
    _nodeItem.completion = 1.0f;
    
    if(self.isCancelled)
    {
        [self finishTask];
        return;
    }
    
    NSString * spoilerDir = [[NSUserDefaults standardUserDefaults] stringForKey:kISpoilerSyncParentDirectory];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString * cacheDir =[spoilerDir stringByAppendingPathComponent:_currentImage.cache.gccode];

    if(![fileManager fileExistsAtPath:cacheDir])
    {
        NSError * error;
        if(![fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:NO attributes:0 error:&error])
        {
            NSLog(@"Could create directory at path : %@ - Error :%@", cacheDir, error.description);

            [self finishTask];
            return;
        }
        
    }
    
    if(self.isCancelled)
    {
        [self finishTask];
        return;
    }
    NSError * error;
    NSString * imagePath = [cacheDir stringByAppendingPathComponent:[_currentImage.name stringByAppendingPathExtension:[_currentImage.url pathExtension]]];
    
    if(![_receivedData writeToFile:imagePath options:0 error:&error])
    {
        NSLog(@"Could not write image at path : %@ - %@", imagePath, error.description);
        
         [self finishTask];
         return;
    }
    _nodeItem.status = YGNodeItemStatusImageConvertingWorking;
    CFStringRef  UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                             (CFStringRef)[imagePath pathExtension],
                                                             NULL);
    if(self.isCancelled)
    {
        [self finishTask];
    }
    if(![self ConvertImageToJPGAtPath:imagePath])
    {
        _nodeItem.status = YGNodeItemStatusImageConvertingError;
        NSLog(@"Failed to convert image to JPG :%@",imagePath);
        CFRelease(UTI);
        [self finishTask];
        return;
    }
    else
    {
        _nodeItem.status = YGNodeItemStatusImageConvertingFinished;
       CFRelease(UTI);
        
        imagePath = [[imagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];

    }
    
    _nodeItem.status = YGNodeItemStatusImageTaggingWorking;
    if(self.isCancelled)
    {
        [self finishTask];
        return;
    }
    
    if(![self GeotagJPGAtPath:imagePath])
    {
         _nodeItem.status = YGNodeItemStatusImageTaggingError;
         [self finishTask];
          return;
    }
    
    _nodeItem.status = YGNodeItemStatusImageTaggingFinished;
    [self finishTask];
    
}
#pragma mark - Helpers

- (BOOL) GeotagJPGAtPath:(NSString *) path{
    
    CFURLRef URL = (CFURLRef) [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL(URL, NULL);
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithURL(URL, kUTTypeJPEG, 0, NULL);
    
    
    if(imageSource == NULL || imageDestination == NULL){
        NSLog(@"Failed to open image at path for geotagging : %@", path);
        return NO;
    }
    
    NSDictionary *metadata = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageSource,0,NULL);
    //make the metadata dictionary mutable so we can add properties to it
    NSMutableDictionary *metadataAsMutable = [[metadata mutableCopy]autorelease];
    [metadata release];
    
    //get mutable gps data
    NSMutableDictionary *GPSDictionary = [[[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy]autorelease];
    if(!GPSDictionary)
    {
        GPSDictionary = [NSMutableDictionary dictionary];
    }
    
    //Get element from cache
    GeoCache * cache  = _currentImage.cache;
    
    double lat = cache.latValue;
    double lon = cache.lonValue;

    NSString * latRef = nil;
    NSString * lonRef = nil;

    if (lat < 0) {
        lat *= -1.0;
        latRef = @"S";
    } else {
        latRef = @"N";
    }

    if (lon < 0) {
        lon *= -1.0;
        lonRef = @"W";
    } else {
        lonRef = @"E";
    }

    [GPSDictionary setObject:[NSNumber numberWithDouble:lat] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    [GPSDictionary setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    
    [GPSDictionary setObject:[NSNumber numberWithDouble:lon] forKey:(NSString*)kCGImagePropertyGPSLongitude];
    [GPSDictionary setObject:lonRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    
    //add our modified GPS data back into the image's metadata
    [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    CGImageDestinationAddImageFromSource(imageDestination, imageSource, 0, (CFDictionaryRef) metadataAsMutable);
    
    BOOL ok =  CGImageDestinationFinalize(imageDestination);
    
    if(!ok)
    {
        NSLog(@"Error during setting metadata to file : %@",imageDestination);
        CFRelease(imageDestination);
        CFRelease(imageSource);
    }
    
    return ok;
}
- (BOOL) ConvertImageToJPGAtPath:(NSString *) path
{
    NSString *newJPGPath = [[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
    
    NSData * imgData = [NSData dataWithContentsOfFile:path] ;
    NSBitmapImageRep* bitmap = [NSBitmapImageRep imageRepWithData: imgData];
    NSData* newData = [bitmap representationUsingType:NSJPEGFileType properties:@{
        NSImageCompressionFactor: @8.0,
    }];

    NSError * error;
    if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
    {
        NSLog(@"Previous file could not be erased : %@", error.description);
    }
    return [newData writeToFile:newJPGPath atomically: NO];
    
}

- (void) updateStatus
{
    YGNodeItem * parentItem  = _nodeItem.parent;
    
    BOOL finished = YES;
    for(YGNodeItem * child in parentItem.childs)
    {
        if(child.status != YGNodeItemStatusImageTaggingFinished)
        {
            finished = NO;
            break;
        }
    }
    if(finished)
    {
        
        parentItem.status = YGNodeItemStatusCacheFinish;
        
        
        YGNodeItem * gpxItem = parentItem.parent;
        
        BOOL gpxFinished = YES;
        for (YGNodeItem * child in gpxItem.childs)
        {
            if(child.status != YGNodeItemStatusCacheFinish && child.status !=YGNodeItemStatusNoImageFound && child.status != YGNodeItemStatusImageError && child.status != YGNodeItemStatusImageError)
            {
                gpxFinished = NO;
                break;
            }
        }
        if(gpxFinished)
        {
            gpxItem.status = YGNodeItemStatusGPXFinished;
        }
        
    }

}
- (void) finishTask
{
    if(self.isCancelled)
    {
        _nodeItem.status = YGNodeItemStatusCancelled;
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

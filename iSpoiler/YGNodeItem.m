//
//  YGNodeItem.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGNodeItem.h"
#import "GeoCache.h"
#import "Image.h"
#import "YGDownloadHTMLOperation.h"
@import Cocoa;
@implementation YGNodeItem

@synthesize parent = _parent;
@synthesize childs = _childs;
@synthesize name = _name;
@synthesize gccode = _gccode;
@synthesize completion = _completion;
@synthesize type = _type;
@synthesize objectID = _objectID;
@synthesize status = _status;

+ (instancetype) node
{
    return [[[self alloc] init] autorelease];
}
- (void) dealloc
{
    [_childs release];
    [_name release];
    
    [self removeObserver:self forKeyPath:@"status"];
    [self removeObserver:self forKeyPath:@"completion"];
    
    [super dealloc];
}
- (id) init
{
    if(self = [super init])
    {
        _completion = -1.0f;
        [self addObserver:self forKeyPath:@"status" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"completion" options:0 context:NULL];

    }
    return self;
}

- (BOOL) isExpandable
{
    return (_childs.count > 0);
}

- (NSArray *) childs
{
    if(!_childs)
    {
        _childs = [[NSMutableArray alloc] init];
    }
    return _childs;
}

-(BOOL) isEqualTo:(id)object
{
    return [[object gccode] isEqualToString:self.gccode];
}

+ (instancetype) nodeFromGPXFile:(GPXFile *) file
{
    YGNodeItem * node = [YGNodeItem node];
    node.name = file.name;
    node.type = YGNodeItemTypeGPX;
    node.objectID = file.objectID;
    
    for(GeoCache * cache in file.caches)
    {
        YGNodeItem * nodeCache = [YGNodeItem node];
        nodeCache.name = cache.name;
        nodeCache.gccode = cache.gccode;
        nodeCache.type = YGNodeItemTypeCache;
        nodeCache.objectID = cache.objectID;
        
        nodeCache.parent = node;
        
        [node.childs addObject:nodeCache];
    }
    return node;
}
- (YGNodeItem *) containsItem:(YGNodeItem *) item
{

    YGNodeItem * found = nil;
    for(YGNodeItem * subItem in self.childs)
    {
        if(subItem == item)
        {
            found = self;
            break;
        }
    }
    return found;
}

+ (instancetype) nodeFromImage:(Image*) image
{
    YGNodeItem * node = [YGNodeItem node];
    
    node.type = YGNodeItemTypeImage;
    node.name = image.name;
    node.objectID =image.objectID ;
    
    return node;
}
#pragma mark - Image

- (NSString*) comment
{
   switch(self.status)
    {
        default:
        case YGNodeItemStatusIdle:
        {
            return nil;
        }
            break;
            
        case YGNodeItemStatusImageWorking:
        {
            return NSLocalizedString(@"Downloading image...",nil);
        }
            break;
        case YGNodeItemStatusHTMLWorking:
        {
            return NSLocalizedString(@"DownloadHTML",nil);
        }
            break;
            
        case YGNodeItemStatusNoImageFound:
        {
            return NSLocalizedString(@"NoSpoilersFound",nil);
        }
            break;
        
        case YGNodeItemStatusHTMLError:
        {
            return NSLocalizedString(@"Error by parsing HTML.",nil);
        }
            break;
        case YGNodeItemStatusHTMLFinished:
        {
            return NSLocalizedString(@"ConvertJPG finished",nil);
        }
            break;
        case YGNodeItemStatusImageError:
        {
            return NSLocalizedString(@"DownloadJPG Error",nil);
        }
            break;
        case YGNodeItemStatusImageFinished:
        {
            return NSLocalizedString(@"DownloadJPG finished",nil);
        }
            break;
        case YGNodeItemStatusImageConvertingError:
        {
            return NSLocalizedString(@"Could not write image to JPG",nil);
        }
            break;
        case YGNodeItemStatusImageConvertingWorking:
        {
            return NSLocalizedString(@"ConvertJPG",nil);
        }
            break;
        case YGNodeItemStatusImageConvertingFinished:
        {
            return NSLocalizedString(@"ConvertJPG finished",nil);
        }
            break;
        case YGNodeItemStatusImageTaggingError:
        {
            return NSLocalizedString(@"Successfully geotag image.",nil);
        }
           break;
        case YGNodeItemStatusImageTaggingWorking:
        {
            return NSLocalizedString(@"Geotagging",nil);
        }
            break;
        case YGNodeItemStatusCacheWorking:
        {
            return NSLocalizedString(@"Processing cache...",nil);
        }
            break;
        case YGNodeItemStatusGPXWorking:
        {
            return NSLocalizedString(@"Processing...",nil);
        }
        case YGNodeItemStatusImageTaggingFinished:
        case YGNodeItemStatusCacheFinish:
        case YGNodeItemStatusGPXFinished:
        {
            return NSLocalizedString(@"Completed",nil);
        }
          break;
        case YGNodeItemStatusCancelled:
        {
            return NSLocalizedString(@"Cancelled",nil);
        }
            break;
    }
}
- (NSImage*) statusImage
{
   
    NSString * imageName = nil;
    
    switch (_status) {
            
        case YGNodeItemStatusImageFinished:
        case YGNodeItemStatusHTMLFinished:
        case YGNodeItemStatusImageConvertingFinished:
        default:
        {
            imageName = nil;
            break;
            
        }
            case YGNodeItemStatusCacheWorking:
            case YGNodeItemStatusImageWorking:
            case YGNodeItemStatusHTMLWorking:
            case YGNodeItemStatusGPXWorking:
        {
            imageName = @"working";
            break;
            
        }
            case YGNodeItemStatusNoImageFound:
            case YGNodeItemStatusImageTaggingFinished:
            case YGNodeItemStatusGPXFinished:
            case YGNodeItemStatusCacheFinish:

        {
            imageName = @"ok";
            break;
            
        }   case YGNodeItemStatusImageError:
            case YGNodeItemStatusHTMLError:
            case YGNodeItemStatusImageConvertingError:
            case YGNodeItemStatusImageTaggingError:

        {
            imageName = @"error";
            break;
            
        }
        case YGNodeItemStatusCancelled:
        {
            imageName = @"stop";
        }
            break;
            
    }
    
    return [NSImage imageNamed:imageName];
}

- (BOOL)isCacheAndFinished
{
    if(self.type != YGNodeItemTypeCache)
        return NO;
    
    BOOL finished = YES;
    for(YGNodeItem * child in self.childs)
    {
            if(child.status != YGNodeItemStatusImageTaggingFinished)
            {
                finished = NO;
                break;
            }
    }
    
    return finished;
}
#pragma mark -  Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"status"] || [keyPath isEqualToString:@"completion"])
    {
        dispatch_async(dispatch_get_main_queue(),^{
           
              [[NSNotificationCenter defaultCenter] postNotificationName:YGCacheRecordChanged object:self];
        });
    }
}
@end

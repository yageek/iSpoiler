//
//  YGNodeItem.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPXFile.h"
#import "Image.h"

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSUInteger, YGNodeItemType){
    YGNodeItemTypeGPX,
    YGNodeItemTypeCache,
    YGNodeItemTypeImage
};


typedef NS_ENUM(NSUInteger, YGNodeItemStatus){
    YGNodeItemStatusIdle,
    YGNodeItemStatusHTMLWorking,
    YGNodeItemStatusHTMLFinished,
    YGNodeItemStatusHTMLError,
    YGNodeItemStatusNoImageFound,
    YGNodeItemStatusImageWorking,
    YGNodeItemStatusImageFinished,
    YGNodeItemStatusImageError,
    YGNodeItemStatusImageConvertingWorking,
    YGNodeItemStatusImageConvertingFinished,
    YGNodeItemStatusImageConvertingError,
    YGNodeItemStatusImageTaggingError,
    YGNodeItemStatusImageTaggingWorking,
    YGNodeItemStatusImageTaggingFinished,
    YGNodeItemStatusCacheWorking,
    YGNodeItemStatusCacheFinish,
    YGNodeItemStatusGPXWorking,
    YGNodeItemStatusGPXFinished,
    YGNodeItemStatusCancelled
    
};

@interface YGNodeItem : NSObject{
    NSMutableArray * _childs;
    NSString * _name;
    NSString * _gccode;
    float _completion;
    YGNodeItemType _type;
    NSManagedObjectID * _objectID;
    YGNodeItem * _parent;
    YGNodeItemStatus _status;
}

+ (instancetype) node;
+ (instancetype) nodeFromGPXFile:(GPXFile *) file;
+ (instancetype) nodeFromImage:(Image*) image;
- (YGNodeItem *) containsItem:(YGNodeItem *) item;
- (NSImage*) statusImage;
- (NSString*) comment;
- (BOOL)isCacheAndFinished;

@property (nonatomic, getter = isExpandable, readonly) BOOL expandable;
@property (nonatomic,copy) NSMutableArray * childs;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * gccode;
@property (nonatomic) float completion;
@property(nonatomic) YGNodeItemType type;
@property(nonatomic,weak) NSManagedObjectID * objectID;

@property(nonatomic)    YGNodeItemStatus status;
@property(nonatomic,assign) YGNodeItem * parent;
@end
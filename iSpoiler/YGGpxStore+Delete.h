//
//  YGGpxStore+Delete.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 04/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore.h"

@interface YGGpxStore (Delete)

- (void) deleteObjectWithID:(NSManagedObjectID*) objectID;
- (void) deleteItem:(YGNodeItem *) item;
- (YGNodeItem *) parentItem:(YGNodeItem*) item InNode:(YGNodeItem * )baseitem;
 @end

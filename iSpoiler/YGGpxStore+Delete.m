//
//  YGGpxStore+Delete.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 04/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore+Delete.h"
#import "YGAppDelegate.h"
@implementation YGGpxStore (Delete)

- (void) deleteObjectWithID:(NSManagedObjectID*) objectID
{
    NSManagedObject * obj = [self.managedObjectContext objectWithID:objectID];
    [self.managedObjectContext deleteObject:obj];
    
    _isCacheInvalide = YES;
}

- (void) deleteItem:(YGNodeItem *) item
{
    [self deleteObjectWithID:item.objectID];
    
    if(!item.parent)
        [self.rootElement.childs removeObject:item];
    else
        [item.parent.childs removeObject:item];
    
    [self.managedObjectContext save:nil];
}


- (YGNodeItem *) parentItem:(YGNodeItem*) item InNode:(YGNodeItem * )baseitem
{
    baseitem = baseitem ?: self.rootElement;
    YGNodeItem * found  = [baseitem containsItem:item];
   if(found)
   {
       return found;
   }
    else
    {
        for(YGNodeItem* subItem in baseitem.childs)
        {
            found = [subItem containsItem:item];
            if(found)
            {
                break;
            }
            
            else
            {
                found = [self parentItem:subItem InNode:item];
            }
        }
        
        if(found)
            return found;
        else
            return nil;
    }
    return nil;
}
@end

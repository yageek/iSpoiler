//
//  YGGpxStore+OutlineViewDataSource.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 23/10/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore+OutlineViewDataSource.h"

@implementation YGGpxStore (OutlineViewDataSource) 

- (id) outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if(!item)
    {
        return [self.rootElement.childs objectAtIndex:index];
    }
    else
    {
        YGNodeItem * element = item;
        return [element.childs objectAtIndex:index];
    }
}

-(BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    YGNodeItem * element = item;
    
    if(!item)
    {
        return self.rootElement.isExpandable;
    }
    else
    {
        element = item;
        return element.isExpandable;
    }
    
}
- (NSInteger) numberOfItems
{
    return self.rootElement.childs.count;
}
-(NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if(!item)
        return self.rootElement.childs.count;
    else
    {
        YGNodeItem * element = item;
        return element.childs.count;
    }
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    YGNodeItem * element = item;
    
    if([tableColumn.identifier isEqualToString:@"name"] && element.type == YGNodeItemTypeGPX)
    {
        return [NSString stringWithFormat:@"%@ (%li caches)",element.name, (unsigned long)element.childs.count];
    }
    else
        return [element valueForKey:tableColumn.identifier];
}
- (void) resetAllNodesInNode:(YGNodeItem *)node
{
    id parent = self.rootElement;
    if(node)
        parent = node;
    
    for(id child in [parent childs])
    {
        [child setStatus:YGNodeItemStatusIdle];
        [self resetAllNodesInNode:child];
    }
    
    return;
}
@end

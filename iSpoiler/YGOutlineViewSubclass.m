//
//  YGOutlineViewSubclass.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 15/11/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGOutlineViewSubclass.h"
#import "YGNodeItem.h"

@implementation YGOutlineViewSubclass


- (void) drawRow:(NSInteger)row clipRect:(NSRect)clipRect
{
//    
//    YGNodeItem * item = [self itemAtRow:row];
//    if([item status] != YGNodeItemStatusIdle)
//    {
//        
//        if([item status] == YGNodeItemStatusWorking)
//        {
//            [[NSColor lightGrayColor] setFill];
//        }
//        else if ([item status] == YGNodeItemStatusError)
//        {
//            [[NSColor redColor] setFill];
//        }
//        else if ([item status] == YGNodeItemStatusFinished)
//        {
//            [[NSColor greenColor] setFill];
//        }
//        
//        NSRectFill(clipRect);
//    }
    
    
    [super drawRow:row clipRect:clipRect];
}
@end

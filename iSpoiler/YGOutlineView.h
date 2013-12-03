//
//  YGOutlineView.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YGNodeItem.h"
#import "YGOutlineViewSubclass.h"
@interface YGOutlineView : NSScrollView{
    YGOutlineViewSubclass * _outlineView;
    id<NSOutlineViewDelegate> _delegate;
    id<NSOutlineViewDataSource> _dataSource;
    
}

@property(assign,nonatomic) id<NSOutlineViewDataSource> dataSource;
@property(assign,nonatomic) id<NSOutlineViewDelegate> delegate;
@property(readonly,nonatomic) YGOutlineViewSubclass * outlineView;

- (BOOL) isSelectionEmpty;
- (YGNodeItem*) selectedItem;

@end

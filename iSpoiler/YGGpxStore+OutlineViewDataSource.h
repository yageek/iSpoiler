//
//  YGGpxStore+OutlineViewDataSource.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 23/10/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore.h"
@import Cocoa;
@interface YGGpxStore (OutlineViewDataSource)<NSOutlineViewDataSource>

- (void) resetAllNodesInNode:(YGNodeItem*) node;
- (NSInteger) numberOfItems;
- (void) clearItems;
@end

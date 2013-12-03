//
//  YGOutlineViewController.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YGOutlineView.h"

@interface YGOutlineViewController : NSViewController <NSOutlineViewDelegate>{
    YGOutlineView * _outlineView;
    NSMenuItem * _deleteMenuItem;
    NSMenuItem * _openGCWebPage;
    
    NSArray * _selectedSets;
}

- (void) refresh;

@end

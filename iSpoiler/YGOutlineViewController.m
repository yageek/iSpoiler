//
//  YGOutlineViewController.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGOutlineViewController.h"
#import "YGGpxStore+Delete.h"
#import "YGGpxStore+OutlineViewDataSource.h"
#import "YGDownloadHTMLOperation.h"

@class YGProgressCell;

@implementation YGOutlineViewController
- (id) init
{
    return [self initWithNibName:nil bundle:nil];
}

- (void) loadView
{
    _outlineView = [[YGOutlineView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    self.view = _outlineView;
    
    _outlineView.dataSource = [YGGpxStore sharedInstance];
    _outlineView.delegate = self;
    
    [self initMenu];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:YGCacheRecordChanged object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *notif){
        
        YGNodeItem * node = notif.object;
        
        if(node.type == YGNodeItemTypeCache)
        {
            [_outlineView.outlineView reloadItem:node reloadChildren:YES];
            [_outlineView.outlineView expandItem:node];
            
        }
        else if(node.type == YGNodeItemTypeImage)
        {
             [_outlineView.outlineView reloadItem:node reloadChildren:NO];

        }
        else if(node.type == YGNodeItemTypeGPX)
        {
            [_outlineView.outlineView reloadItem:node];
        }
        
    }];
    
    
}


- (void) refresh
{
    [_outlineView.outlineView reloadData];
    
}

- (void) dealloc
{

    [_outlineView release];
    [_selectedSets release];
    [super dealloc];
}
#pragma mark - Delegate
- (BOOL) outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    YGNodeItem * element = item;
    return element.isExpandable;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
    return YES;
}

#pragma mark - Menu
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if([menuItem isEqual:_deleteMenuItem])
    {
        return ![_outlineView isSelectionEmpty];
    }
    else if([menuItem isEqual:_openGCWebPage])
    {
        YGNodeItem * item = [_outlineView selectedItem];
        return (item.type == YGNodeItemTypeCache);
    }
    return YES;
}
- (void) initMenu
{
    NSMenu * menu = [[NSMenu alloc] initWithTitle:@"Menu"];
    
    _deleteMenuItem = [menu addItemWithTitle:NSLocalizedString(@"Delete",nil) action:@selector(deleteClick:) keyEquivalent:@""];
    [_deleteMenuItem setTarget:self];
    
    _openGCWebPage = [menu addItemWithTitle:NSLocalizedString(@"View on Geocaching.com",nil) action:@selector(openGClick:) keyEquivalent:@""];
    [_openGCWebPage setTarget:self];
    
    [_outlineView.outlineView setMenu:menu];
}

- (void) deleteClick:(id) sender
{
    NSIndexSet * rowSet = [_outlineView.outlineView selectedRowIndexes];

    [rowSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){

        YGNodeItem * element = [_outlineView.outlineView itemAtRow:idx];
        [[YGGpxStore sharedInstance] deleteItem:element];
        [_outlineView.outlineView deselectRow:idx];
        
    }];
    [self refresh];
}

- (void) openGClick:(id)sender
{
    YGNodeItem * item = [_outlineView selectedItem];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.coord.info/%@",item.gccode]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}


@end

//
//  YGOutlineView.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGOutlineView.h"
#import "YGProgressCell.h"
@implementation YGOutlineView

@synthesize outlineView = _outlineView;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initOutlineView];
        [self initColumns];
    }
    return self;
}

- (void) setDataSource:(id<NSOutlineViewDataSource>)dataSource
{
    _outlineView.dataSource = dataSource;
}

- (void) setDelegate:(id<NSOutlineViewDelegate>)delegate
{
    _outlineView.delegate = delegate;
}

- (void) initOutlineView
{
    _outlineView = [[YGOutlineViewSubclass alloc] initWithFrame:self.contentView.frame];
    _outlineView.usesAlternatingRowBackgroundColors = YES;
    _outlineView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask | NSTableViewSolidVerticalGridLineMask;

    
    [self setDocumentView:_outlineView];
    
    self.hasVerticalScroller = YES;
    self.hasHorizontalScroller = YES;
    self.hasHorizontalRuler = NO;
    self.autohidesScrollers = YES;
    _outlineView.allowsMultipleSelection  = YES;
    
    [_outlineView release];
}

- (void) initColumns
{
    
    NSTableColumn * statusColumn = [[NSTableColumn alloc] initWithIdentifier:@"statusImage"];
    [statusColumn.headerCell setStringValue:@""];
    statusColumn.minWidth = 32;
    statusColumn.maxWidth = 32;
    statusColumn.width = 32;
    [statusColumn setResizingMask:NSTableColumnAutoresizingMask|NSTableColumnUserResizingMask];
    statusColumn.dataCell = [[NSImageCell alloc] initImageCell:nil];
 
    NSTableColumn * nameColumn = [[NSTableColumn alloc] initWithIdentifier:@"name"];
    [nameColumn.headerCell setStringValue:NSLocalizedString(@"Name", nil)];
    nameColumn.minWidth = 16;
    nameColumn.width = 236;
    [nameColumn setResizingMask:NSTableColumnAutoresizingMask|NSTableColumnUserResizingMask];
    
    NSTableColumn * gccodeColumn = [[NSTableColumn alloc] initWithIdentifier:@"gccode"];
    [gccodeColumn.headerCell setStringValue:@"GCCode"];
    gccodeColumn.width = 70;
    gccodeColumn.maxWidth = 70;
    gccodeColumn.minWidth = 70;
    
    NSTableColumn * progressColumn = [[NSTableColumn alloc] initWithIdentifier:@"completion"];
    [progressColumn.headerCell setStringValue:NSLocalizedString(@"Process", nil)];
    
    
    YGProgressCell * levelCell = [[YGProgressCell alloc] init];
    [progressColumn setDataCell:levelCell];
    
    NSTableColumn * commentColumn = [[NSTableColumn alloc] initWithIdentifier:@"comment"];
    [commentColumn.headerCell setStringValue:@""];
    
    [_outlineView addTableColumn:statusColumn];
    [_outlineView addTableColumn:nameColumn];
    [_outlineView addTableColumn:gccodeColumn];
    [_outlineView addTableColumn:progressColumn];
    [_outlineView addTableColumn:commentColumn];
    
    [_outlineView setOutlineTableColumn:nameColumn];
    
    [nameColumn release];
    [gccodeColumn release];
    [progressColumn release];

}
- (BOOL) isSelectionEmpty
{
    return ([[self.outlineView selectedRowIndexes] count] == 0);
}
- (YGNodeItem*) selectedItem
{
    return [self.outlineView itemAtRow:[self.outlineView selectedRow]];
}
@end


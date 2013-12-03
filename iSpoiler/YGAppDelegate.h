//
//  YGAppDelegate.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YGOutlineViewController.h"
@interface YGAppDelegate : NSObject <NSApplicationDelegate> {
    NSToolbarItem *_downloadToolBarItem;
    NSTextField *_statusBarTextField;
    NSProgressIndicator *_statusBarProgressIndicator;
    NSToolbar *_toolbar;
    YGOutlineViewController * _outlineViewController;
    NSWindow * _window;
    
    IBOutlet NSView * _accessoryView;
    
    NSToolbarItem *_importToolBarItem;
    NSToolbarItem *_exportToolBarItem;
    BOOL _isProcessing, _isStopping;
    
    NSOperationQueue * _exportQueue;
    NSUInteger _jobsNumber;
    BOOL _downloadSpoilersOnly;
    
    IBOutlet NSWindow * _exportWindow;
    IBOutlet NSProgressIndicator *_exportPanelProgressBar;
}
@property(readwrite) BOOL downloadSpoilersOnly;
@property(readwrite) NSUInteger jobsNumber;
@property (assign) IBOutlet NSToolbarItem *importToolBarItem;
@property (assign) IBOutlet NSToolbarItem *exportToolBarItem;

@property (assign) IBOutlet NSToolbarItem *downloadToolBarItem;
@property (assign) IBOutlet NSTextField *statusBarTextField;
@property (assign) IBOutlet NSProgressIndicator *statusBarProgressIndicator;

@property (assign) IBOutlet NSToolbar *toolbar;
@property (assign) IBOutlet NSWindow *window;
@property(readonly) YGOutlineViewController * outlineViewController;

-( void) setProcessing:(BOOL) processing;
-( void) setStopping:(BOOL) processing;
@end

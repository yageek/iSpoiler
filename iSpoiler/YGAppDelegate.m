//
//  YGAppDelegate.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGAppDelegate.h"
#import "YGGpxStore+Fetching.h"
#import "YGAppDelegate+StatusBar.h"
#import "YGAppDelegate+Download.h"
#import "YGDownloadManager.h"

#define kExpireAppStoreUnderstood @"net.yageek.iSpoiler.expireAppStoreUnderstood"

@implementation YGAppDelegate

@synthesize importToolBarItem = _importToolBarItem;
@synthesize exportToolBarItem = _exportToolBarItem;
@synthesize downloadToolBarItem = _downloadToolBarItem;
@synthesize statusBarTextField = _statusBarTextField;
@synthesize statusBarProgressIndicator = _statusBarProgressIndicator;
@synthesize toolbar = _toolbar;
@synthesize window = _window;
@synthesize outlineViewController =_outlineViewController;
@synthesize jobsNumber = _jobsNumber;
@synthesize downloadSpoilersOnly = _downloadSpoilersOnly;

- (IBAction)seeOnGithubTriggered:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://yageek.github.io/iSpoiler"]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    [self initStatusBar];
    
    
    _outlineViewController = [[YGOutlineViewController alloc] init];
    [self setMainViewControllerAccordingToBorder:_outlineViewController];
    
    
    self.jobsNumber = 5;
    self.downloadSpoilersOnly = NO;
    _isProcessing = NO;
    _isStopping = NO;
    

    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kExpireAppStoreUnderstood : @NO}];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kISpoilerSyncParentDirectory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _exportQueue = [[NSOperationQueue alloc] init];
    [_exportQueue setName:@"net.yageek.iSpoiler.exportingQueue"];

    [[YGDownloadManager sharedInstance] setCompletionBlock:^{
        
        
        self.downloadToolBarItem.image = [NSImage imageNamed:@"run"];
        [self.downloadToolBarItem setTarget:self];
        [self.downloadToolBarItem setAction:@selector(downloadButtonTriggered:)];
        [self.downloadToolBarItem setLabel:NSLocalizedString(@"Download",nil)];
        
        [self setStopping:NO];
        [self setProcessing:NO];
        
        
    }];
}


- (void) setMainViewControllerAccordingToBorder:(NSViewController*) controller
{
    NSRect contentRect = [self.window.contentView frame];
    CGFloat yOffset = [self.window contentBorderThicknessForEdge:NSMinYEdge];
    
    contentRect.size.height -= yOffset;
    contentRect.origin.y += yOffset;
    
    controller.view.frame = contentRect;
    
    controller.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [self.window.contentView addSubview:controller.view];
    
}
-(void) setProcessing:(BOOL) processing
{
    _isProcessing = processing;
    [self.toolbar validateVisibleItems];
}
-(void) setStopping:(BOOL) processing
{
    _isStopping = processing;
    [self.toolbar validateVisibleItems];
}
#pragma mark - Close windows -> http://www.cocoanetics.com/2013/01/3-mac-tidbits/
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}
@end

//
//  YGAppDelegate+StatusBar.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGAppDelegate+StatusBar.h"
#import "YGGpxStore+OutlineViewDataSource.h"
@implementation YGAppDelegate (StatusBar)

- (void) setStatusBarHidden:(BOOL) hidden
{
    [self.statusBarTextField setHidden:hidden];
    [self.statusBarProgressIndicator setHidden:hidden];
}
- (void) initStatusBar
{
    self.statusBarProgressIndicator.minValue = 0;
    self.statusBarProgressIndicator.maxValue = 100;
    
    [self setStatusBarHidden:YES];
}
- (void) setProgress:(CGFloat) value
{
    self.statusBarProgressIndicator.doubleValue = value;
}
- (void) setStatusTextValue:(NSString*) value
{
    [self.statusBarTextField setStringValue:value];
}

- (BOOL) validateToolbarItem:(NSToolbarItem *)theItem
{
    if(theItem == self.downloadToolBarItem)
    {
        if([[YGGpxStore sharedInstance] numberOfItems] <= 0)
            return NO;
        else
            return !_isStopping;
    }
    else
        return !_isProcessing;

}
@end

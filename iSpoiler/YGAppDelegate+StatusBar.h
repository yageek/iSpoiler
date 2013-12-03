//
//  YGAppDelegate+StatusBar.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGAppDelegate.h"

@interface YGAppDelegate (StatusBar)

- (void) initStatusBar;
- (void) setStatusBarHidden:(BOOL) hidden;
- (void) setProgress:(CGFloat) value;
- (void) setStatusTextValue:(NSString*) value;
@end

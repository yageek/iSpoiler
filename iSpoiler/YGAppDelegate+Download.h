//
//  YGAppDelegate+Download.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGAppDelegate.h"

#define defaultSyncFolderName @"iSpoilerSync"
#define kISpoilerSyncParentDirectory @"iSpoilerSyncParent"

@interface YGAppDelegate (Download) <NSAlertDelegate>
- (IBAction)downloadButtonTriggered:(id)sender;

@end

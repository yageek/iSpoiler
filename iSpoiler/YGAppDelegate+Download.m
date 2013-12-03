//
//  YGAppDelegate+Download.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGAppDelegate+Download.h"
#import "YGDownloadManager.h"
#import "YGGpxStore+OutlineViewDataSource.h"


@implementation YGAppDelegate (Download)

- (NSView*) accessoryView
{
    if(!_accessoryView)
    {
        [NSBundle loadNibNamed:@"AccessoryView" owner:self];
    }
    
    return _accessoryView;
}

- (IBAction)downloadButtonTriggered:(id)sender
{
    NSLog(@"Start downloading");
    
    NSOpenPanel * oPanel = [NSOpenPanel openPanel];
    
    oPanel.canCreateDirectories = YES;
    oPanel.canChooseFiles = NO;
    oPanel.canChooseDirectories = YES;
    oPanel.allowsMultipleSelection = NO;
    oPanel.accessoryView = [self accessoryView];
    
    
    [oPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){

        [[YGDownloadManager sharedInstance] setConcurrentOperationsNumber:self.jobsNumber];
        
        if(result == NSOKButton)
        {
            NSLog(@"Save files to :%@",oPanel.URL);
            
            NSString * iSpoilerDir = [oPanel.URL.path stringByAppendingPathComponent:defaultSyncFolderName];
            
            [[NSUserDefaults standardUserDefaults] setValue:iSpoilerDir forKey:kISpoilerSyncParentDirectory];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            BOOL isDir = NO;
            if([[NSFileManager defaultManager] fileExistsAtPath:iSpoilerDir isDirectory:&isDir] && isDir)
            {
                NSLog(@"Directory already exists!");
                
                NSAlert *alert  =[NSAlert alertWithMessageText:NSLocalizedString(@"DirectoryExistMessage",nil) defaultButton:NSLocalizedString(@"Cancel",nil) alternateButton:NSLocalizedString(@"Delete",nil) otherButton:Nil informativeTextWithFormat:@""];
                
                
                [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(iSpoilerSyncAlertDidEnd:returnCode:contextInfo:) contextInfo:&iSpoilerDir];

                return;
            }
            
                [self downloadAllElements];
            
        }
         
     }];
}

#pragma mark - Alert view return functions
- (void) iSpoilerSyncAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    NSString * iSpoilerDir = [[NSUserDefaults standardUserDefaults] valueForKey:kISpoilerSyncParentDirectory];
    
    switch(returnCode)
    {
        case NSAlertDefaultReturn :
        {
            break;
        }
            
        case NSAlertAlternateReturn:
        {
            NSError * error = nil;
            if(![[NSFileManager defaultManager] removeItemAtPath:iSpoilerDir error:&error])
            {
                NSLog(@"Could not remove item at path : %@ - Reason : %@",iSpoilerDir,error);
                 [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
                return;
            }
            
            [self downloadAllElements];
            break;
        }
    }
}

- (void) downloadAllElements
{
    [[YGGpxStore sharedInstance] resetAllNodesInNode:nil];

    [self setProcessing:YES];
    NSString *iSpoilerDir = [[NSUserDefaults standardUserDefaults] valueForKey:kISpoilerSyncParentDirectory];
    NSError *error = nil;
    if(![[NSFileManager defaultManager] createDirectoryAtPath:iSpoilerDir withIntermediateDirectories:YES attributes:nil error:&error])
    {
        NSLog(@"Could not create item at path : %@ - Reason : %@",iSpoilerDir,error);
        
        NSAlert * alert  = [NSAlert alertWithError:error];
        [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];

        [self setProcessing:NO];
        return;
    }
    
    YGGpxStore * store = [YGGpxStore sharedInstance];
    YGNodeItem * root = store.rootElement;
    
    for(YGNodeItem * gpxType in root.childs)
    {
        gpxType.status = YGNodeItemStatusGPXWorking;
        
        for(YGNodeItem * cacheType in gpxType.childs)
        {
            [[YGDownloadManager sharedInstance] addItemToDownload:cacheType];
        }
    }
    
    self.downloadToolBarItem.image = [NSImage imageNamed:@"stop"];
    [self.downloadToolBarItem setTarget:self];
    [self.downloadToolBarItem setAction:@selector(stop:)];
    [self.downloadToolBarItem setLabel:NSLocalizedString(@"Cancel",nil)];
}

- (void) stop:(id)sender
{
     [self setStopping:YES];
     [[YGDownloadManager sharedInstance] stopDownload];
}
@end

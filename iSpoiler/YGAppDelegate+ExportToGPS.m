//
//  YGAppDelegate+ExportToGPS.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 03/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGAppDelegate+ExportToGPS.h"
#import "YGAppDelegate+Download.h"
#import "YGExportOperation.h"


@implementation YGAppDelegate (ExportToGPS)
- (IBAction)exportButtonTriggered:(id)sender
{
    NSString * defaults = [[NSUserDefaults standardUserDefaults] stringForKey:kISpoilerSyncParentDirectory] ;
    if(!defaults)
    {
        [self choosePreexisitingiSpoilerSyncDir];
        return;
    }
    
    NSOpenPanel * oPanel = [NSOpenPanel openPanel];
    
    oPanel.canCreateDirectories = YES;
    oPanel.canChooseFiles = NO;
    oPanel.canChooseDirectories = YES;
    oPanel.allowsMultipleSelection = NO;
    
    [oPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result)
     {
         if(result == NSFileHandlingPanelOKButton)
         {
             NSFileManager * fileManager = [NSFileManager defaultManager];
             NSString * outputDir = [[oPanel URL] path];
             NSString *writingPath = [outputDir stringByAppendingPathComponent:@"GeocachePhotos"];
            
             BOOL isDir;
             if([fileManager fileExistsAtPath:writingPath isDirectory:&isDir] && isDir)
             {
                 NSAlert * alert = [NSAlert alertWithMessageText:NSLocalizedString(@"DirectoryExportMessage",nil) defaultButton:NSLocalizedString(@"Erase",nil) alternateButton:NSLocalizedString(@"Cancel",nil) otherButton:nil informativeTextWithFormat:@""];
                 
                 NSInteger result = [alert runModal];
                 
                 if(result == NSAlertDefaultReturn)
                 {
                     NSError * error = nil;
                     if(![fileManager removeItemAtPath:writingPath error:&error])
                     {
                         
                         NSAlert * alert = [NSAlert alertWithError:error];
                         [alert runModal];
                         return;
                     }
                     else
                     {
                        [self startOperationAtPath:writingPath];
                     }
                     
                 }
             }
             else
             {
                 [self startOperationAtPath:writingPath];
             }
             
         }
     }];
    
}

- (void) startOperationAtPath:(NSString *) writingPath
{
    if ([NSBundle loadNibNamed:@"ExportView" owner:self])
    {
        _exportPanelProgressBar.minValue = 0;
        [_exportPanelProgressBar startAnimation:self];
        
    }
    
    [NSApp beginSheet:_exportWindow modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:NULL];
        
    
    
    YGExportOperation * op = [[YGExportOperation alloc] initWithExportPath:writingPath];
    
    [op setCompletionBlock:^{
    
        [NSApp endSheet:_exportWindow];
        [_exportPanelProgressBar stopAnimation:self];
        [_exportWindow close];
        
        

    }];
    [_exportQueue addOperation:op];
    
    [op release];
}

- (void) choosePreexisitingiSpoilerSyncDir
{
    NSOpenPanel * oPanel = [NSOpenPanel openPanel];
    
    oPanel.canCreateDirectories = YES;
    oPanel.canChooseFiles = NO;
    oPanel.canChooseDirectories = YES;
    oPanel.allowsMultipleSelection = NO;
    oPanel.title = NSLocalizedString(@"Select the iSpoilerSync directory", nil);
    
    [oPanel beginWithCompletionHandler:^(NSInteger result)
     {
         if(result == NSFileHandlingPanelOKButton)
         {
             NSString *ispoilerPath = [[oPanel URL] path];
             
             if(![[ispoilerPath lastPathComponent] isEqualToString:@"iSpoilerSync"])
             {
                 
                 NSAlert * alert = [NSAlert alertWithMessageText:NSLocalizedString(@"No iSpoilerSync folder found", nil) defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:NSLocalizedString(@"No iSpoilerSync folder was found.", nil)];
                 [alert runModal];
                 
                 return;
             }
             
             [[NSUserDefaults standardUserDefaults] setObject:[[oPanel URL] path] forKey:kISpoilerSyncParentDirectory];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [self exportButtonTriggered:self];
         }
         
     }];


}
@end

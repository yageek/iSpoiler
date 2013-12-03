//
//  YGAppDelegate+importGPX.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGAppDelegate+importGPX.h"
#import "YGGpxStore+ImportGPX.h"
#import "YGAppDelegate+StatusBar.h"
#import "GPXFile.h"
#import "GeoCache.h"


@implementation YGAppDelegate (importGPX)
-(IBAction)importGPXClicked:(id)sender
{
    NSLog(@"%@ - Import GPX",[self class]);

    NSOpenPanel * oPanel = [NSOpenPanel openPanel];

    oPanel.allowedFileTypes = @[@"gpx"];
    oPanel.allowsMultipleSelection = YES;
    oPanel.canChooseDirectories = NO;
    oPanel.canChooseFiles = YES;

    [oPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        
        if(result == NSOKButton)
        {
            NSArray * urls = oPanel.URLs;
            NSLog(@"Load files:%@", urls);
            
            [self.statusBarTextField setHidden:NO];
            [self setStatusTextValue:@"Processing GPX"];
            
            [[YGGpxStore sharedInstance] addGPXFromURLS:urls WithCompletionBlock:^(NSError * error){
                
                if(error)
                {
                    NSError * error = [NSError errorWithDomain:@"self"code:11 userInfo:nil];
                    NSLog(@"%s - Error during import : %@ ",__PRETTY_FUNCTION__,[error description]);
                    
                    NSAlert * alertView = [NSAlert alertWithError:error];
                    [alertView beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:NULL];
                }
                else
                {
                    
                    [self reloadData];
                }
                
                NSString * string = [NSString stringWithFormat:@"%li file(s) imported",(unsigned long)urls.count];
                [self setStatusTextValue:string];
            }];
        }
 
    }];
}

- (void) reloadData
{
    [_outlineViewController refresh];
    [self.toolbar validateVisibleItems];
}

@end

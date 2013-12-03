//
//  YGExportOperation.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 03/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGExportOperation.h"
#import "YGAppDelegate+Download.h"
#define TEMP_SUBNAME @"net.yageek.ispoiler"

@implementation YGExportOperation

- (id) initWithExportPath:(NSString*) path
{
    if(self = [super init])
    {
        _exportPath = [path copy];
    }
    return self;
}

- (void) start
{
    if(self.isCancelled)
        return;
    [self main];
}
- (void) main
{
     NSString * tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:TEMP_SUBNAME];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:tempPath])
    {
        NSError * error;
        if(![fm removeItemAtPath:tempPath error:&error])
        {
            NSLog(@"Error on deleting temp path at %@ : %@",tempPath,[error description]);
            return;
        }
    }
    
    NSString * iSpoilerSyncDir = [[NSUserDefaults standardUserDefaults] stringForKey:kISpoilerSyncParentDirectory];
    
    NSError * error = nil;
    NSArray* cachesDirectories = [fm contentsOfDirectoryAtPath:iSpoilerSyncDir error:&error];
    if(!cachesDirectories)
    {
        NSLog(@"Error on listing cache at path : %@ - Error : %@", iSpoilerSyncDir, error.description);
        return;
    }
    
    [cachesDirectories enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        
        if([obj isEqualToString:@".DS_Store"])
            return;
        
        NSString * cachePath =[iSpoilerSyncDir stringByAppendingPathComponent:obj];
      
        
        NSError * error;
        NSArray * images  = [fm contentsOfDirectoryAtPath:cachePath error:&error];
        
        if(!images)
        {
            NSLog(@"Error on listing cache at path : %@ - Error : %@", cachePath, error.description);
            return ;
        }
        
        NSString * garminPrefix, *lastChar, *lastSecondChar;
        lastChar = [obj substringFromIndex:[obj length] -1];
        if([obj length] < 3)
        {
            lastSecondChar = @"0";
        }
        else
        {
            
            lastSecondChar = [obj substringWithRange:NSMakeRange([obj length]-2, 1)];
        }

        garminPrefix = [NSString stringWithFormat:@"%@/%@/%@",lastChar,lastSecondChar,obj];
        
        NSString * tempSubDir = [tempPath stringByAppendingPathComponent:garminPrefix];
        
        if(![fm createDirectoryAtPath:tempSubDir withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Could not create directory at path : %@ - Error :%@", tempSubDir, error.description);
            return;

        }
        
        BOOL hasSpoilersDir = NO;

        for(NSString * image in images)
        {
            if([image isEqualToString:@".DS_Store"])
                continue;
         
            NSString * orgPath = [cachePath stringByAppendingPathComponent:image];
            NSString * destPath = nil;
            if([image rangeOfString:@"spoiler" options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                NSString *spoilersSubDir = [tempSubDir stringByAppendingPathComponent:@"Spoilers"];
                if(!hasSpoilersDir)
                {
                    if(![fm createDirectoryAtPath:spoilersSubDir withIntermediateDirectories:NO attributes:nil error:&error])
                    {
                        NSLog(@"Could not create directory at path : %@ - Error :%@", spoilersSubDir, error.description);
                        continue;
                    }
                    
                    hasSpoilersDir = YES;
                }
                
                destPath = [spoilersSubDir stringByAppendingPathComponent:image];
            }
            else
            {
                destPath = [tempSubDir stringByAppendingPathComponent:image];
            }
            
            if(![fm copyItemAtPath:orgPath toPath:destPath error:&error])
            {
                NSLog(@"Error copying item : %@", error.description);
            }
        }

    }];
    
    if(![fm copyItemAtPath:tempPath toPath:_exportPath error:&error])
    {
         NSLog(@"Error copying item : %@", error.description);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self completionBlock]();
        
        NSURL * url = [NSURL fileURLWithPath:_exportPath isDirectory:YES];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:[[url URLByDeletingLastPathComponent] path] isDirectory:YES]];

    });
}

- (void) dealloc
{
    [_exportPath release];
    [super dealloc];
}
@end

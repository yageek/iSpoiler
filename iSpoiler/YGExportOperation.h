//
//  YGExportOperation.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 03/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGExportOperation : NSOperation
{
    NSString * _exportPath;
}

- (id) initWithExportPath:(NSString*) path;

@end

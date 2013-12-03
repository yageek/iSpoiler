//
//  YGGpxStore+ImportGPX.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore.h"
#import "YGBlockTypes.h"

@interface YGGpxStore (ImportGPX)

- (void) addGPXFromURLS:(NSArray*) urls WithCompletionBlock:(error_block) block;
@end

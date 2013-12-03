//
//  YGGpxStore+Fetching.h
//  iSpoiler
//
//  Created by Yannick Heinrich on 02/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGpxStore.h"

typedef void(^fetch_result_completion_t)(NSArray * result,NSError * error);

@interface YGGpxStore (Fetching)

- (void) fetchAllGeocaches:(fetch_result_completion_t) block;

- (BOOL) isEmpty;

@end

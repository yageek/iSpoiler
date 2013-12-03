//
//  YGBlockTypes.h
//  iSpoiler
//
//  Created by HEINRICH Yannick on 28/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#ifndef iSpoiler_YGBlockTypes_h
#define iSpoiler_YGBlockTypes_h
#import <Foundation/Foundation.h>
#import "GPXFile.h"
typedef void(^gpx_import_completion_t)(NSManagedObjectID * fileID, NSError * error);
typedef void(^error_block)(NSError * error);
typedef void(^gpx_import_coredata_completion_t)(NSError * error, NSManagedObjectID * objectID);

#endif

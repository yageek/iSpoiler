// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GPXFile.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class GeoCache;

@interface GPXFileID : NSManagedObjectID {}
@end

@interface _GPXFile : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GPXFileID *objectID;

@property (nonatomic, strong, nullable) NSDate* generatedTime;

@property (nonatomic, strong, nullable) NSDate* importedDate;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSSet<GeoCache*> *caches;
- (nullable NSMutableSet<GeoCache*>*)cachesSet;

@end

@interface _GPXFile (CachesCoreDataGeneratedAccessors)
- (void)addCaches:(NSSet<GeoCache*>*)value_;
- (void)removeCaches:(NSSet<GeoCache*>*)value_;
- (void)addCachesObject:(GeoCache*)value_;
- (void)removeCachesObject:(GeoCache*)value_;

@end

@interface _GPXFile (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveGeneratedTime;
- (void)setPrimitiveGeneratedTime:(NSDate*)value;

- (NSDate*)primitiveImportedDate;
- (void)setPrimitiveImportedDate:(NSDate*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet<GeoCache*>*)primitiveCaches;
- (void)setPrimitiveCaches:(NSMutableSet<GeoCache*>*)value;

@end

@interface GPXFileAttributes: NSObject 
+ (NSString *)generatedTime;
+ (NSString *)importedDate;
+ (NSString *)name;
@end

@interface GPXFileRelationships: NSObject
+ (NSString *)caches;
@end

NS_ASSUME_NONNULL_END

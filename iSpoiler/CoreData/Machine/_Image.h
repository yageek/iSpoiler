// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class GeoCache;

@interface ImageID : NSManagedObjectID {}
@end

@interface _Image : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ImageID *objectID;

@property (nonatomic, strong, nullable) NSNumber* downloaded;

@property (atomic) BOOL downloadedValue;
- (BOOL)downloadedValue;
- (void)setDownloadedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* type;

@property (atomic) int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* url;

@property (nonatomic, strong, nullable) GeoCache *cache;

@end

@interface _Image (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveDownloaded;
- (void)setPrimitiveDownloaded:(nullable NSNumber*)value;

- (BOOL)primitiveDownloadedValue;
- (void)setPrimitiveDownloadedValue:(BOOL)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(nullable NSString*)value;

- (nullable GeoCache*)primitiveCache;
- (void)setPrimitiveCache:(nullable GeoCache*)value;

@end

@interface ImageAttributes: NSObject 
+ (NSString *)downloaded;
+ (NSString *)name;
+ (NSString *)type;
+ (NSString *)url;
@end

@interface ImageRelationships: NSObject
+ (NSString *)cache;
@end

NS_ASSUME_NONNULL_END

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeoCache.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class GPXFile;
@class Image;

@interface GeoCacheID : NSManagedObjectID {}
@end

@interface _GeoCache : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GeoCacheID *objectID;

@property (nonatomic, strong, nullable) NSString* gccode;

@property (nonatomic, strong, nullable) NSNumber* lat;

@property (atomic) double latValue;
- (double)latValue;
- (void)setLatValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* lon;

@property (atomic) double lonValue;
- (double)lonValue;
- (void)setLonValue:(double)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) GPXFile *gpxFile;

@property (nonatomic, strong, nullable) NSSet<Image*> *images;
- (nullable NSMutableSet<Image*>*)imagesSet;

@end

@interface _GeoCache (ImagesCoreDataGeneratedAccessors)
- (void)addImages:(NSSet<Image*>*)value_;
- (void)removeImages:(NSSet<Image*>*)value_;
- (void)addImagesObject:(Image*)value_;
- (void)removeImagesObject:(Image*)value_;

@end

@interface _GeoCache (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveGccode;
- (void)setPrimitiveGccode:(nullable NSString*)value;

- (nullable NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(nullable NSNumber*)value;

- (double)primitiveLatValue;
- (void)setPrimitiveLatValue:(double)value_;

- (nullable NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(nullable NSNumber*)value;

- (double)primitiveLonValue;
- (void)setPrimitiveLonValue:(double)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable GPXFile*)primitiveGpxFile;
- (void)setPrimitiveGpxFile:(nullable GPXFile*)value;

- (NSMutableSet<Image*>*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet<Image*>*)value;

@end

@interface GeoCacheAttributes: NSObject 
+ (NSString *)gccode;
+ (NSString *)lat;
+ (NSString *)lon;
+ (NSString *)name;
@end

@interface GeoCacheRelationships: NSObject
+ (NSString *)gpxFile;
+ (NSString *)images;
@end

NS_ASSUME_NONNULL_END

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeoCache.h instead.

#import <CoreData/CoreData.h>


extern const struct GeoCacheAttributes {
	 NSString *gccode;
	 NSString *lat;
	 NSString *lon;
	 NSString *name;
} GeoCacheAttributes;

extern const struct GeoCacheRelationships {
	 NSString *gpxFile;
	 NSString *images;
} GeoCacheRelationships;

extern const struct GeoCacheFetchedProperties {
} GeoCacheFetchedProperties;

@class GPXFile;
@class Image;






@interface GeoCacheID : NSManagedObjectID {}
@end

@interface _GeoCache : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GeoCacheID*)objectID;





@property (nonatomic, retain) NSString* gccode;



//- (BOOL)validateGccode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* lat;



@property double latValue;
- (double)latValue;
- (void)setLatValue:(double)value_;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* lon;



@property double lonValue;
- (double)lonValue;
- (void)setLonValue:(double)value_;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) GPXFile *gpxFile;

//- (BOOL)validateGpxFile:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet *images;

- (NSMutableSet*)imagesSet;





@end

@interface _GeoCache (CoreDataGeneratedAccessors)

- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(Image*)value_;
- (void)removeImagesObject:(Image*)value_;

@end

@interface _GeoCache (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveGccode;
- (void)setPrimitiveGccode:(NSString*)value;




- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (double)primitiveLatValue;
- (void)setPrimitiveLatValue:(double)value_;




- (NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSNumber*)value;

- (double)primitiveLonValue;
- (void)setPrimitiveLonValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (GPXFile*)primitiveGpxFile;
- (void)setPrimitiveGpxFile:(GPXFile*)value;



- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;


@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

#import <CoreData/CoreData.h>


extern const struct ImageAttributes {
	 NSString *downloaded;
	 NSString *name;
	 NSString *type;
	 NSString *url;
} ImageAttributes;

extern const struct ImageRelationships {
	 NSString *cache;
} ImageRelationships;

extern const struct ImageFetchedProperties {
} ImageFetchedProperties;

@class GeoCache;






@interface ImageID : NSManagedObjectID {}
@end

@interface _Image : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ImageID*)objectID;





@property (nonatomic, retain) NSNumber* downloaded;



@property BOOL downloadedValue;
- (BOOL)downloadedValue;
- (void)setDownloadedValue:(BOOL)value_;

//- (BOOL)validateDownloaded:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* type;



@property int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) GeoCache *cache;

//- (BOOL)validateCache:(id*)value_ error:(NSError**)error_;





@end

@interface _Image (CoreDataGeneratedAccessors)

@end

@interface _Image (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDownloaded;
- (void)setPrimitiveDownloaded:(NSNumber*)value;

- (BOOL)primitiveDownloadedValue;
- (void)setPrimitiveDownloadedValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int16_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int16_t)value_;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (GeoCache*)primitiveCache;
- (void)setPrimitiveCache:(GeoCache*)value;


@end

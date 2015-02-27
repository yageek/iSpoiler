// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GPXFile.h instead.

#import <CoreData/CoreData.h>

extern const struct GPXFileAttributes {
	 NSString *generatedTime;
	 NSString *importedDate;
	 NSString *name;
} GPXFileAttributes;

extern const struct GPXFileRelationships {
	 NSString *caches;
} GPXFileRelationships;

@class GeoCache;

@interface GPXFileID : NSManagedObjectID {}
@end

@interface _GPXFile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GPXFileID* objectID;

@property (nonatomic, retain) NSDate* generatedTime;

//- (BOOL)validateGeneratedTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSDate* importedDate;

//- (BOOL)validateImportedDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet *caches;

- (NSMutableSet*)cachesSet;

@end

@interface _GPXFile (CachesCoreDataGeneratedAccessors)
- (void)addCaches:(NSSet*)value_;
- (void)removeCaches:(NSSet*)value_;
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

- (NSMutableSet*)primitiveCaches;
- (void)setPrimitiveCaches:(NSMutableSet*)value;

@end

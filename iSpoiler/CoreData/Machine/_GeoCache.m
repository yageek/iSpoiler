// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeoCache.m instead.

#import "_GeoCache.h"

@implementation GeoCacheID
@end

@implementation _GeoCache

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GeoCache" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GeoCache";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GeoCache" inManagedObjectContext:moc_];
}

- (GeoCacheID*)objectID {
	return (GeoCacheID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"latValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lonValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lon"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic gccode;

@dynamic lat;

- (double)latValue {
	NSNumber *result = [self lat];
	return [result doubleValue];
}

- (void)setLatValue:(double)value_ {
	[self setLat:@(value_)];
}

- (double)primitiveLatValue {
	NSNumber *result = [self primitiveLat];
	return [result doubleValue];
}

- (void)setPrimitiveLatValue:(double)value_ {
	[self setPrimitiveLat:@(value_)];
}

@dynamic lon;

- (double)lonValue {
	NSNumber *result = [self lon];
	return [result doubleValue];
}

- (void)setLonValue:(double)value_ {
	[self setLon:@(value_)];
}

- (double)primitiveLonValue {
	NSNumber *result = [self primitiveLon];
	return [result doubleValue];
}

- (void)setPrimitiveLonValue:(double)value_ {
	[self setPrimitiveLon:@(value_)];
}

@dynamic name;

@dynamic gpxFile;

@dynamic images;

- (NSMutableSet<Image*>*)imagesSet {
	[self willAccessValueForKey:@"images"];

	NSMutableSet<Image*> *result = (NSMutableSet<Image*>*)[self mutableSetValueForKey:@"images"];

	[self didAccessValueForKey:@"images"];
	return result;
}

@end

@implementation GeoCacheAttributes 
+ (NSString *)gccode {
	return @"gccode";
}
+ (NSString *)lat {
	return @"lat";
}
+ (NSString *)lon {
	return @"lon";
}
+ (NSString *)name {
	return @"name";
}
@end

@implementation GeoCacheRelationships 
+ (NSString *)gpxFile {
	return @"gpxFile";
}
+ (NSString *)images {
	return @"images";
}
@end


// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GPXFile.m instead.

#import "_GPXFile.h"

@implementation GPXFileID
@end

@implementation _GPXFile

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GPXFile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GPXFile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GPXFile" inManagedObjectContext:moc_];
}

- (GPXFileID*)objectID {
	return (GPXFileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic generatedTime;

@dynamic importedDate;

@dynamic name;

@dynamic caches;

- (NSMutableSet<GeoCache*>*)cachesSet {
	[self willAccessValueForKey:@"caches"];

	NSMutableSet<GeoCache*> *result = (NSMutableSet<GeoCache*>*)[self mutableSetValueForKey:@"caches"];

	[self didAccessValueForKey:@"caches"];
	return result;
}

@end

@implementation GPXFileAttributes 
+ (NSString *)generatedTime {
	return @"generatedTime";
}
+ (NSString *)importedDate {
	return @"importedDate";
}
+ (NSString *)name {
	return @"name";
}
@end

@implementation GPXFileRelationships 
+ (NSString *)caches {
	return @"caches";
}
@end


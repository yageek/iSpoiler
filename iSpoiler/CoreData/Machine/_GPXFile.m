// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GPXFile.m instead.

#import "_GPXFile.h"

const struct GPXFileAttributes GPXFileAttributes = {
	.generatedTime = @"generatedTime",
	.importedDate = @"importedDate",
	.name = @"name",
};

const struct GPXFileRelationships GPXFileRelationships = {
	.caches = @"caches",
};

const struct GPXFileFetchedProperties GPXFileFetchedProperties = {
};

@implementation GPXFileID
@end

@implementation _GPXFile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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

	
- (NSMutableSet*)cachesSet {
	[self willAccessValueForKey:@"caches"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"caches"];
  
	[self didAccessValueForKey:@"caches"];
	return result;
}
	






@end

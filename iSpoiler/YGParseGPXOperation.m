//
//  YGParseGPXOperation.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGParseGPXOperation.h"

#define GROUNDSPEAK_URI @"http://www.groundspeak.com/cache/1/0/1"


@implementation YGParseGPXOperation

-(void) setCompletionBlock:(void (^)(void))block
{
    //Do nothing
}

- (id) initWithGPXURL:(NSURL*) url WithCoordinator:(NSPersistentStoreCoordinator *) storeCoordinator andCompletionblock:(gpx_import_completion_t) block

{
    if(self= [super init])
    {
        _gpxURL = [url retain];
        _persistantStoreCoordinator = [storeCoordinator retain];
        _completionBlock = [block copy];
    }
    return self;
}

- (void) dealloc
{
    [_gpxURL release];
    [_persistantStoreCoordinator release];
    [_completionBlock release];
    [super dealloc];
}
#pragma mark - NSOperation element
- (BOOL) isConcurrent
{
    return YES;
}

- (void) main
{
    NSLog(@"Start GPX processing of : %@",_gpxURL);
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:_persistantStoreCoordinator];

    
    NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:_gpxURL];
    parser.delegate = self;
    parser.shouldProcessNamespaces = YES;

    BOOL ok = [parser parse];
    NSLog(@"Parsing ended");

    __block NSError * processError = nil;

    if(!ok)
    {
        processError = [parser parserError];
    }
    else
    {
        
        [_managedObjectContext save:&processError];
    }
    
    [_managedObjectContext release];
    [parser release];
    
    if(_completionBlock)
    {
       _completionBlock(_currentFile.objectID,processError);
    }

}

#pragma mark - XML parser delegate

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"gpx"])
    {
        _currentFile = [NSEntityDescription insertNewObjectForEntityForName:@"GPXFile" inManagedObjectContext:_managedObjectContext];
    }
    else if([elementName isEqualToString:@"wpt"])
    {
        _currentCache  = [GeoCache insertInManagedObjectContext:_managedObjectContext];

        _currentCache.lat = @([[attributeDict valueForKey:@"lat"] doubleValue]);
        _currentCache.lon = @([[attributeDict valueForKey:@"lon"] doubleValue]);

        _currentCache.gpxFile = _currentFile;

    }
}
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!_currentValue)
    {
        _currentValue = [[NSMutableString alloc] init];
    }
    [_currentValue appendString:string];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString * value = [_currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([elementName isEqualToString:@"name"] && !_currentCache)
    {
        _currentFile.name = value;
    }
    else if([elementName isEqualToString:@"name"] && _currentCache && ![namespaceURI isEqualToString:GROUNDSPEAK_URI])
    {
        _currentCache.gccode = value;
    }
    else if([elementName isEqualToString:@"name"] && _currentCache && [namespaceURI isEqualToString:GROUNDSPEAK_URI])
    {
        _currentCache.name = value;
    }
    else if([elementName isEqualToString:@"wpt"])
    {

        [_currentFile addCachesObject:_currentCache];
        _currentCache = nil;
    }
    [_currentValue release];
    _currentValue = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    _currentFile.importedDate = [NSDate date];
}
@end

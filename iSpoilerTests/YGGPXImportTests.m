//
//  YGImportGPXTests.m
//  iSpoiler
//
//  Created by HEINRICH Yannick on 27/08/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "YGParseGPXOperation.h"
#import "GeoCache.h"

static NSManagedObjectContext * _testContext;
static NSPersistentStoreCoordinator * _store;
static NSManagedObjectModel * _managedObjectModel;

SpecBegin(GPXImport)

describe(@"GPX Import",^{

    beforeAll(^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GpxModel" withExtension:@"momd"];

        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        _store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

        NSError *error = nil;
        [_store addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];

        expect(error).to.beNil();

        _testContext = [[NSManagedObjectContext alloc] init];
        [_testContext setPersistentStoreCoordinator:_store];

        [Expecta setAsynchronousTestTimeout:10.0];
        
        
    });

    it(@"should import GPX into context",^AsyncBlock{

        NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"gpxTest" ofType:@"bundle"];
        NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
        NSURL * gpxURL = [bundle URLForResource:@"STRASBOURG" withExtension:@"gpx"];

        YGParseGPXOperation * op = [[YGParseGPXOperation alloc] initWithGPXURL:gpxURL WithCoordinator:_store andCompletionblock:^(NSManagedObjectID * fileID, NSError * error){
            dispatch_async(dispatch_get_main_queue(), ^{
                expect(error).to.beNil();
            });
            if(error)
            {
                NSLog(@"Error : %@", error.description);
            }
            done();
        }];


        [[NSOperationQueue mainQueue] addOperation:op];
        [op release];


    });
    
    it(@"should import have GCCode equals to GC2VP3A", ^AsyncBlock{
        
        
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"gpxTest" ofType:@"bundle"];
        NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
        NSURL * gpxURL = [bundle URLForResource:@"Example_iCaching" withExtension:@"gpx"];
        

        YGParseGPXOperation * op = [[YGParseGPXOperation alloc] initWithGPXURL:gpxURL WithCoordinator:_store andCompletionblock:^(NSManagedObjectID * fileID, NSError * error){
            dispatch_async(dispatch_get_main_queue(), ^{
                expect(error).to.beNil();
                
                if(!error)
                {
                    
                    GPXFile * file = (GPXFile*) [_testContext existingObjectWithID:fileID error:nil];
                    
                    expect(file.caches.count).to.equal(1);
                    
                    GeoCache * firstCache = [file.caches anyObject];
                    
                    expect(firstCache.gccode).to.equal(@"GC2VP3A");
                    
                    
                }
                done();

            });
        }];
        
        
        [[NSOperationQueue mainQueue] addOperation:op];
        [op release];

    
    });

    afterAll(^{

        [_testContext release];
        [_store release];
        [_managedObjectModel release];
    });
    
    
    
});

SpecEnd
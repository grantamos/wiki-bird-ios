//
//  main.m
//  WikiBirdImporter
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/29/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#include "Bird.h"
#include "State.h"
#include "BirdGroup.h"
#include "BirdImage.h"

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    NSString *path = @"WikiBird";
    path = [path stringByDeletingPathExtension];
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[NSProcessInfo processInfo] arguments][0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSDictionary *options = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"} };
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:options error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

static NSDictionary *openJSON(NSString *filename)
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
    
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    if (data == nil)
    {
        NSLog(@"Failed to open file from NSBundle's mainBundle.");
        return nil;
    }
    
    NSError* error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    
    if (error != nil)
    {
        NSLog(@"Failed to open JSON data. %@", error.description);
        return nil;
    }
    
    return json;
}

//Helper method to delete all objects from a specific table/entity
static void deleteAllObjects(NSString *entityDescription)
{
    NSManagedObjectContext *context = managedObjectContext();
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesPropertyValues = NO;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items)
    {
        [context deleteObject:managedObject];
    }
}

static NSManagedObject *getObject(NSString *entityName, NSPredicate *predicate)
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext()];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchResults = [managedObjectContext()
                             executeFetchRequest:fetchRequest
                             error:&error];
    
    if (error)
    {
        NSLog(@"Failed to fetch %@: %@", entityName, [error description]);
        return nil;
    }
    
    NSManagedObject *obj = nil;
    
    if ([fetchResults count] == 0)
    {
        obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext()];
    }
    else
    {
        obj = [fetchResults firstObject];
    }
    
    return obj;
}

static void insertBirds(NSDictionary *birds)
{
    int i = 0;
    deleteAllObjects(@"Bird");
    
    for (NSString *birdName in birds)
    {
        NSLog(@"Bird %d/%ld", i++, [birds count]);
        NSDictionary *birdDict = [birds objectForKey:birdName];
        Bird *bird = [NSEntityDescription insertNewObjectForEntityForName:@"Bird" inManagedObjectContext:managedObjectContext()];
        
        if ([birdDict objectForKey:@"commonName"])
            bird.commonName = [birdDict objectForKey:@"commonName"];
        if ([birdDict objectForKey:@"scientificName"])
            bird.scientificName = [birdDict objectForKey:@"scientificName"];
        if ([birdDict objectForKey:@"url"])
            bird.wikiURL = [birdDict objectForKey:@"url"];
        if ([birdDict objectForKey:@"intro"] && ![[birdDict objectForKey:@"intro"] isKindOfClass:[NSNull class]])
            bird.summary = [birdDict objectForKey:@"intro"];
        
        for (NSString *stateName in [birdDict objectForKey:@"states"])
        {
            State *state = (State*)getObject(@"State", [NSPredicate predicateWithFormat:@"name == %@", stateName]);
            state.name = stateName;
            
            [bird addStatesObject:state];
        }
        
        BOOL first = YES;
        
        for (NSString *imageURL in [birdDict objectForKey:@"images"])
        {
            BirdImage *birdImage = (BirdImage*)getObject(@"BirdImage", [NSPredicate predicateWithFormat:@"url == %@", imageURL]);
            
            if (birdImage == nil)
            {
                birdImage = (BirdImage*)[NSEntityDescription insertNewObjectForEntityForName:@"BirdImage" inManagedObjectContext:managedObjectContext()];
            
                birdImage.url = imageURL;
            }
            
            birdImage.bird = bird;
            
            if (first)
            {
                if (birdImage.image != nil)
                {
                    first = NO;
                    continue;
                }
                
                NSLog(@"Fetching bird image %@", imageURL);
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                      returningResponse:&response
                                                                  error:&error];
                
                if (error != nil)
                {
                    NSLog(@"Failed to fetch image %@: %@", imageURL, error);
                }
                else
                {
                    first = NO;
                    birdImage.image = data;
                }
            }
        }
    }
}

static void insertBirdGroups(NSDictionary *birdGroups)
{
    deleteAllObjects(@"BirdGroup");
    
    for (NSString *birdGroupName in birdGroups)
    {
        NSDictionary *birdGroupDict = [birdGroups objectForKey:birdGroupName];
        BirdGroup *birdGroup = [NSEntityDescription insertNewObjectForEntityForName:@"BirdGroup" inManagedObjectContext:managedObjectContext()];
        
        if ([birdGroupDict objectForKey:@"name"])
            birdGroup.name = [birdGroupDict objectForKey:@"name"];
        if ([birdGroupDict objectForKey:@"description"])
            birdGroup.summary = [birdGroupDict objectForKey:@"description"];
        if ([birdGroupDict objectForKey:@"family"])
            birdGroup.scientificFamily = [birdGroupDict objectForKey:@"family"];
        if ([birdGroupDict objectForKey:@"order"])
            birdGroup.scientificOrder = [birdGroupDict objectForKey:@"order"];
        
        for (NSString *birdName in [birdGroupDict objectForKey:@"birds"])
        {
            Bird *bird = (Bird*)getObject(@"Bird", [NSPredicate predicateWithFormat:@"commonName == %@", birdName]);
            
            [birdGroup addBirdsObject:bird];
        }
    }
}

static void importData()
{
    NSDictionary *json = openJSON(@"wikiBird.json");
    
    if (json == nil)
        return;
    
    NSDictionary *birds = [json objectForKey:@"birds"];
    insertBirds(birds);
    
    NSDictionary *birdGroups = [json objectForKey:@"birdGroups"];
    insertBirdGroups(birdGroups);
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        
        importData();
        
        // Save the managed object context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
    }
    return 0;
}


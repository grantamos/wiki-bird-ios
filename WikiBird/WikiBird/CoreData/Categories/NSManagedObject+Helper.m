//
//  NSManagedObject+Helper.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/27/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "NSManagedObject+helper.h"
#import "ManagedObjectContext.h"

@implementation NSManagedObject (helper)

+ (NSManagedObjectContext*) managedObjectContext
{
    return [[ManagedObjectContext sharedInstance] managedObjectContext];
}

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
{
    return [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}

+ (NSArray *)findAllObjects;
{
    return [self findAllObjectsInContext:[self managedObjectContext]];
}

+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context;
{
    return [self findObjectsWithPredicate:nil inContext:context];
}

+ (NSManagedObject*)findObjectWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    [request setEntity:entity];
    
    if (predicate)
        [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error != nil)
    {
        return nil;
    }
    
    return [results firstObject];
}

+ (NSArray*)findObjectsWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    [request setEntity:entity];
    
    if (predicate)
        [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error != nil)
    {
        return nil;
    }
    
    return results;
}

+ (NSManagedObject*)create
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[self managedObjectContext]];
}

- (void)deleteFromContext
{
    [[self managedObjectContext] deleteObject:self];
}

@end

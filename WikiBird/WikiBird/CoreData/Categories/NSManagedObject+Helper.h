//
//  NSManagedObject+Helper.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/27/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helper)

+ (NSManagedObjectContext*) managedObjectContext;
+ (NSArray *)findAllObjects;
+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context;
+ (NSManagedObject*)findObjectWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context;
+ (NSArray*)findObjectsWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context;
+ (NSManagedObject*)create;

- (void)deleteFromContext;

@end

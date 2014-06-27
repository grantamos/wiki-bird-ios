//
//  NSManagedObject+Helper.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/27/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "NSManagedObject+Helper.h"
#import "ManagedObjectContext.h"

@implementation NSManagedObject (Helper)

+ (NSManagedObjectContext*)mainContext
{
    return [[ManagedObjectContext sharedInstance] managedObjectContext];
}

+ (NSManagedObject*)create
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[self mainContext]];
}

@end

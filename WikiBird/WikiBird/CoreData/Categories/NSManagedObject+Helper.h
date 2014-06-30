//
//  NSManagedObject+Helper.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/27/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helper)

+ (NSManagedObjectContext*)mainContext;
+ (NSManagedObject*)create;

@end

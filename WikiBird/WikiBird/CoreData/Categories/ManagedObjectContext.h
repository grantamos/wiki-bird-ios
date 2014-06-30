//
//  ManagedObjectContext.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/26/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagedObjectContext : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (ManagedObjectContext*)sharedInstance;

- (void)saveContext;

@end

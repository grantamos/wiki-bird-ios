//
//  Bird.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/26/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BirdGroup;

@interface Bird : NSManagedObject

@property (nonatomic, retain) NSString * commonName;
@property (nonatomic, retain) NSString * scientificName;
@property (nonatomic, retain) NSString * wikiURL;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) BirdGroup *birdGroup;
@property (nonatomic, retain) NSSet *states;
@property (nonatomic, retain) NSManagedObject *images;
@end

@interface Bird (CoreDataGeneratedAccessors)

- (void)addStatesObject:(NSManagedObject *)value;
- (void)removeStatesObject:(NSManagedObject *)value;
- (void)addStates:(NSSet *)values;
- (void)removeStates:(NSSet *)values;

@end

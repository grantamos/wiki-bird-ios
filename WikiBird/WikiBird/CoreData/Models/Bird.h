//
//  Bird.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/30/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BirdGroup, BirdImage, State;

@interface Bird : NSManagedObject

@property (nonatomic, retain) NSString * commonName;
@property (nonatomic, retain) NSString * scientificName;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * wikiURL;
@property (nonatomic, retain) BirdGroup *birdGroup;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *states;
@end

@interface Bird (CoreDataGeneratedAccessors)

- (void)addImagesObject:(BirdImage *)value;
- (void)removeImagesObject:(BirdImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addStatesObject:(State *)value;
- (void)removeStatesObject:(State *)value;
- (void)addStates:(NSSet *)values;
- (void)removeStates:(NSSet *)values;

@end

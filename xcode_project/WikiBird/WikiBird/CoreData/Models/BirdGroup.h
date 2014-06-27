//
//  BirdGroup.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/26/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BirdGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * scientificOrder;
@property (nonatomic, retain) NSString * scientificFamily;
@property (nonatomic, retain) NSSet *birds;
@end

@interface BirdGroup (CoreDataGeneratedAccessors)

- (void)addBirdsObject:(NSManagedObject *)value;
- (void)removeBirdsObject:(NSManagedObject *)value;
- (void)addBirds:(NSSet *)values;
- (void)removeBirds:(NSSet *)values;

@end

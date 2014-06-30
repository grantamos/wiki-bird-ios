//
//  State.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/26/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bird;

@interface State : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *birds;
@end

@interface State (CoreDataGeneratedAccessors)

- (void)addBirdsObject:(Bird *)value;
- (void)removeBirdsObject:(Bird *)value;
- (void)addBirds:(NSSet *)values;
- (void)removeBirds:(NSSet *)values;

@end

//
//  BirdImage.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/30/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bird;

@interface BirdImage : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Bird *bird;

@end

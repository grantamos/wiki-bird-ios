//
//  BirdTableViewController.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/30/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "BirdGroup.h"

@interface BirdTableViewController : CoreDataTableViewController

@property (strong, nonatomic) BirdGroup *birdGroup;

@end

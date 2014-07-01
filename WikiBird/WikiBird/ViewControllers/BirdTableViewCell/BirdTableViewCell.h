//
//  BirdTableViewCell.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/30/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirdTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *commonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scientificNameLabel;

@end

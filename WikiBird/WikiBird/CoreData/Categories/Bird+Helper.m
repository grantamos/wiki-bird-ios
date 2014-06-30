//
//  Bird+Helper.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/27/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "Bird+Helper.h"
#import "BirdImage+Helper.h"
#import "FlickrAPI.h"

@implementation Bird (Helper)

- (void)fetchImages
{
    [[FlickrAPI sharedInstance]
     getPhotosForQuery:self.commonName
     withCompletionHandler:^(NSDictionary *data) {
         
         NSArray *photos = [[data objectForKey:@"photos"] objectForKey:@"photo"];
         
         for (NSDictionary *photo in photos)
         {
             [BirdImage createBirdImageWithData:photo andBird:self];
         }
    }];
}

@end

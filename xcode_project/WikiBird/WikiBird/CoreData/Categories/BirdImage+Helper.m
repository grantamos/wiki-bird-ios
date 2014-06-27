//
//  BirdImage+Helper.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/27/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "BirdImage+Helper.h"
#import "NSManagedObject+Helper.h"

@implementation BirdImage (Helper)

+ (void)createBirdImageWithData:(NSDictionary*)data andBird:(Bird*)bird
{
    BirdImage *birdImage = (BirdImage*)[self create];
    
    //{ "id": "12274384383", "owner": "19085189@N03", "secret": "81328ff5db", "server": "3719", "farm": 4, "title": "wood duck", "ispublic": 1, "isfriend": 0, "isfamily": 0 },

    NSString *farmId = [data objectForKey:@"farm"];
    NSString *server = [data objectForKey:@"server"];
    NSString *photoId = [data objectForKey:@"id"];
    NSString *secret = [data objectForKey:@"secret"];
    
    birdImage.url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmId, server, photoId, secret];
    
    birdImage.bird = bird;
}

@end

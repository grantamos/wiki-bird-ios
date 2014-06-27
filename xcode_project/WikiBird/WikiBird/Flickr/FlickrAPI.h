//
//  FlickrAPI.h
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/26/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrAPI : NSObject

+ (FlickrAPI*)sharedInstance;

- (void)getPhotosForQuery:(NSString*)query
    withCompletionHandler:(void (^)(NSDictionary*))completionHandler;

@end

//
//  FlickrAPI.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/26/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "FlickrAPI.h"

@implementation FlickrAPI
{
    NSURLSession *_session;
    NSString *_apiKey;
}

+ (FlickrAPI*)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _session = [NSURLSession sharedSession];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"api_key" ofType:@"txt"];
        NSError *error = nil;
        
        _apiKey = [NSString stringWithContentsOfFile:path
                                            encoding:NSUTF8StringEncoding
                                               error:&error];
        
        if (error)
        {
            NSLog(@"Failed to open api_key.");
            _apiKey = @"";
        }
    }
    
    return self;
}

- (void)getPhotosForQuery:(NSString*)query withCompletionHandler:(void (^)(NSDictionary*))completionHandler
{
    [_session dataTaskWithURL:[self flickrURLWithQuery:query]
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode != 200)
        {
            NSLog(@"Media request failed with status code: %d", httpResponse.statusCode);
            NSLog(@"Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        NSError *jsonError = nil;
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError)
        {
            NSLog(@"Failed to convert json data to NSDictionary.");
            return;
        }
        
        completionHandler(root);
    }];
}

- (NSURL*)flickrURLWithQuery:(NSString*)query
{
    return [NSURL URLWithString:
            [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&sort=relevance&format=json&nojsoncallback=1",
             _apiKey,
             [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

@end

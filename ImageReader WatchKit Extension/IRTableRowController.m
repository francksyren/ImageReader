//
//  WMTableRowController.m
//  WatchMe
//
//  Created by Syren, Franck on 1/9/15.
//  Copyright (c) 2015 Syren, Franck. All rights reserved.
//

#import "IRTableRowController.h"

@implementation IRTableRowController

-(void)setPost:(Post *)post {

    _post = post;
    
    [self.postTile setText:post.title];
    self.link = post.webLink;
    
    [self.postMovie setHidden:post.type != PostTypeAnimated];
    [self.postImage setHidden:post.type != PostTypePhoto];
    
    if (post.type == PostTypeAnimated) {
        [self.postMovie setMovieURL:post.imageUrl];
        [self.postMovie setLoops:YES];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:post.thumbnailUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:5.0];
        [request setHTTPMethod:@"GET"];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     
                                                                     
                                                                     [self.postMovie setPosterImage:[WKImage imageWithImageData:data]];
                                                                     
                                                                 }];
        [task resume];
        
    }
    else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:post.imageUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:5.0];
        [request setHTTPMethod:@"GET"];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     
                                                                     [self.postImage setImageData:data];
                                                                     
                                                                     
                                                                 }];
        [task resume];
        
        
    }
}

@end

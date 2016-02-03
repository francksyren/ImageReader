//
//  WMShareController.m
//  WatchMe
//
//  Created by Syren, Franck on 1/12/15.
//  Copyright (c) 2015 Syren, Franck. All rights reserved.
//

#import "IRShareController.h"
#import "InterfaceController.h"

@interface IRShareController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceMovie *movie;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *image;

@end



@implementation IRShareController



-(instancetype)init {
    self = [super init];
    if (self) {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession];
            session.delegate = self;
            [session activateSession];
        }

    }
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.post = context;
    [self.titleLabel setText:self.post.title];
    
    [self.movie setHidden:self.post.type != PostTypeAnimated];
    [self.image setHidden:self.post.type != PostTypePhoto];
    

    if (self.post.type == PostTypeAnimated) {
        [self.movie setMovieURL:self.post.imageUrl];
        [self.movie setLoops:YES];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.post.thumbnailUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:5.0];
        [request setHTTPMethod:@"GET"];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     
                                                                     
                                                                     [self.movie setPosterImage:[WKImage imageWithImageData:data]];
                                                                     
                                                                 }];
        [task resume];
        
    }
    else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.post.detailImageUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:5.0];
        [request setHTTPMethod:@"GET"];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     
                                                                     
                                                                     [self.image setImageData:data];
                                                                     
                                                                 }];
        [task resume];
        
    }
    
}


- (void)willActivate {
    // This method is called when the controller is about to be visible to the wearer.
    //NSLog(@"%@ will activate", self);
}

- (void)didDeactivate {
    // This method is called when the controller is no longer visible.
    //NSLog(@"%@ did deactivate", self);
}

- (IBAction)upvote {
    
}

- (IBAction)shareByEmail {
    

    if ([[WCSession defaultSession] isReachable]) {
    
        NSDictionary *applicationDict = @{@"link": self.post.webLink};
        [[WCSession defaultSession] sendMessage:applicationDict
                                   replyHandler:^(NSDictionary *replyHandler) {
                                       NSLog(@"reply is ok %@", replyHandler);
                                   }
                                   errorHandler:^(NSError *error) {
                                       
                                   }
         ];

    }
    else {
        NSLog(@"not reachable");
    }
}

@end

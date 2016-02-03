//
//  InterfaceController.m
//  WatchMe WatchKit Extension
//
//  Created by Syren, Franck on 12/10/14.
//  Copyright (c) 2014 Syren, Franck. All rights reserved.
//

#import "InterfaceController.h"
#import "IRTableRowController.h"
#import "TRVSURLSessionOperation.h"
#import "Post.h"

#define BASE_SERVICE_URL    "https://m.9gag.com"

#define UI_THRESHOLD        5
#define REQUEST_THRESHOLD   @"10"

@interface InterfaceController() {

    NSUInteger currentIndex;
}

@property (strong) NSOperationQueue *postsQueue;
@property (strong) NSOperationQueue *imagesQueue;

@property (weak, nonatomic) IBOutlet WKInterfaceTable *postsTable;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *moreButton;

@property (strong, nonatomic) NSMutableArray<Post *> *posts;
@property (strong, nonatomic) NSString *lastPageID;

@end


@implementation InterfaceController



- (instancetype)init {
    self = [super init];
    if (self){
        
        self.posts = [NSMutableArray new];
        
        self.postsQueue = [[NSOperationQueue alloc] init];
        self.imagesQueue = [[NSOperationQueue alloc] init];
        
//        NSLog(@"\n%@\n", [[UIDevice currentDevice] name]);
//        [[WKInterfaceDevice currentDevice] addCachedImage:[UIImage imageNamed:@"shareicon.png"] name:@"shareicon.png"];
        
        _lastPageID = nil;
        currentIndex = 0;
        
        [self refresh];

        // configure menu item
        // opened when user long click on the watch
//        [self addMenuItemWithItemIcon:WKMenuItemIconInfo title:@"hot" action:@selector(showHot)];
//        [self addMenuItemWithItemIcon:WKMenuItemIconShare title:@"trending" action:@selector(showTrending)];
        
        [self addMenuItemWithItemIcon:WKMenuItemIconResume title:@"Refresh" action:@selector(fullRefresh)];

    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    //NSLog(@"%@ will activate", self);
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    //NSLog(@"%@ did deactivate", self);
}


-(void) fullRefresh {

    [self.postsQueue cancelAllOperations];
    [self.imagesQueue cancelAllOperations];
    
    _lastPageID = @"0";
    currentIndex = 0;
    [self.postsTable setNumberOfRows:0 withRowType:@"default"];
    

    [self refresh];
}


- (void) refresh {
    
    [self.posts removeAllObjects];

    [self.moreButton setTitle:@"Loading..."];
    [self.moreButton setEnabled:NO];

    NSURLRequest *request = [self createRequest];
    

    InterfaceController *_weakSelf = self;

    TRVSURLSessionOperation *operation =  [[TRVSURLSessionOperation alloc] initWithSession:[NSURLSession sharedSession]
                                                                                   request:request
                                                                         completionHandler:^(NSData *urlData, NSURLResponse *response, NSError *connectionError) {
        
        [self.moreButton setTitle:@"Load more"];
        [self.moreButton setEnabled:YES];
        
        if (urlData == nil || connectionError != nil){
            [self.moreButton setTitle:@"Try again"];
            NSLog(@"no data, error %@", connectionError);
            return;
        }
        NSError *jsonParsingError = nil;
        id myDict = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&jsonParsingError];
        
        // to load next page later on
        _lastPageID = [[[[myDict objectForKey:@"data"] objectForKey:@"loadMoreRef"] componentsSeparatedByString:@","] lastObject];
        
        if (jsonParsingError) {
            NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
        }
        else {
            [[[myDict objectForKey:@"data"] objectForKey:@"posts"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [_weakSelf.posts addObject:[Post postFromDictionary:obj]];
            }];
            
            [_weakSelf.postsTable setNumberOfRows:UI_THRESHOLD withRowType:@"default"];
            
            [_weakSelf displayRowsFrom:0 To:UI_THRESHOLD];
            currentIndex += UI_THRESHOLD;
        }

    }];

    [self.postsQueue addOperation:operation];
    
    
}

-(NSURLRequest *)createRequest {

    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%s/hot", BASE_SERVICE_URL]];
    urlComponents.queryItems = @[
                                 [NSURLQueryItem queryItemWithName:@"c" value:REQUEST_THRESHOLD],
                                 [NSURLQueryItem queryItemWithName:@"id" value:_lastPageID]
                                 ];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlComponents.URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"application/json, text/javascript, */*; q=0.01" forHTTPHeaderField:@"Accept"];
    [request setValue:@"gzip, deflate, sdch" forHTTPHeaderField:@"Accept-Encoding"];
    
    return request;
}


- (void) displayRowsFrom:(long)fromIndex To:(long)toIndex {

    for (long idx = fromIndex; idx < self.posts.count && idx < toIndex; ++idx) {

        IRTableRowController *row = [self.postsTable rowControllerAtIndex:idx];
        
        Post *post = self.posts[idx];
        [row setPost:post];
    }
    
    
}

- (IBAction)loadMore {

    if (currentIndex >= self.posts.count) {

        currentIndex = 0;
        
        [self refresh];
    }
    
    else {
        NSUInteger postsCount = self.posts.count;
        NSUInteger length = UI_THRESHOLD;
        if (postsCount < currentIndex + UI_THRESHOLD) {
            length = postsCount - currentIndex;
        }
        
        [self.postsTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(currentIndex, length)] withRowType:@"default"];
        
        
        [self displayRowsFrom:currentIndex To:currentIndex + length];
        currentIndex += UI_THRESHOLD;
        
    }
    
}

/**
 * delegate
 * called when user selects a row
 */
- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    IRTableRowController *row = [table rowControllerAtIndex:rowIndex];
    [self pushControllerWithName:@"shareController" context:row.post];
}

@end




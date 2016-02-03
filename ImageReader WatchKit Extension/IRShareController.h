//
//  WMShareController.h
//  WatchMe
//
//  Created by Syren, Franck on 1/12/15.
//  Copyright (c) 2015 Syren, Franck. All rights reserved.
//

@import WatchKit;
@import WatchConnectivity;
#import "Post.h"

@interface IRShareController : WKInterfaceController<WCSessionDelegate>

@property(nonatomic,weak) Post *post;

@end

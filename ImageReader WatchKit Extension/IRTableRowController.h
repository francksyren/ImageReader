//
//  WMTableRowController.h
//  WatchMe
//
//  Created by Syren, Franck on 1/9/15.
//  Copyright (c) 2015 Syren, Franck. All rights reserved.
//

@import WatchKit;
#import "Post.h"

@interface IRTableRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *postGroup;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *postTile;

@property (weak, nonatomic) IBOutlet WKInterfaceImage *postImage;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceMovie *postMovie;


@property (strong, nonatomic) WKImage *posterImg;

@property (weak, nonatomic) NSString *postId;

/**
 * URL for the web
 */
@property (weak, nonatomic) NSString *link;

/**
 * Path to the image
 */
@property (weak, nonatomic) NSString *path;


@property(weak,nonatomic) Post *post;

@end

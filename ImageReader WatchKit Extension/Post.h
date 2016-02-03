//
//  Post.h
//  ImageReader
//
//  Created by Syren, Franck on 2/1/16.
//  Copyright © 2016 Syren, Franck. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    PostTypePhoto,
    PostTypeAnimated
};
typedef NSUInteger PostType;

@interface Post : NSObject

+(instancetype)postFromDictionary:(NSDictionary *)dict;

@property(nonatomic,strong) NSString *postId;
@property(nonatomic,strong) NSString *webLink;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSURL *imageUrl;
@property(nonatomic,strong,readonly) NSURL *detailImageUrl;
@property(nonatomic,strong) NSURL *thumbnailUrl;
@property(nonatomic,assign) PostType type;
@property(nonatomic,assign) NSInteger upVoteCount;
@property(nonatomic,assign) BOOL hasLongPostCover;

@end

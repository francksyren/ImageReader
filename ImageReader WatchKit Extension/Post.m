//
//  Post.m
//  ImageReader
//
//  Created by Syren, Franck on 2/1/16.
//  Copyright © 2016 Syren, Franck. All rights reserved.
//

#import "Post.h"
#import "NSString+HTML.h"

@interface Post()
{
    NSURL *longPostImageURL;
}

@end

@implementation Post

-(instancetype)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    
    self.postId = dict[@"id"];
    self.webLink = dict[@"url"];
    self.title = [dict[@"title"] stringByConvertingHTMLToPlainText];
    self.type = [dict[@"type"] isEqualToString:@"Animated"] ? PostTypeAnimated : PostTypePhoto;
    
    self.hasLongPostCover = [dict[@"hasLongPostCover"] boolValue];
    self.upVoteCount = [dict[@"hasLongPostCover"] intValue];
    
    switch (self.type) {
        case PostTypePhoto:

            if (self.hasLongPostCover) {
                self.imageUrl = [Post URLFromDict:dict andKey:@"image220x145"];
                longPostImageURL = [Post URLFromDict:dict andKey:@"image460"];
            }
            else {
                self.imageUrl = [Post URLFromDict:dict andKey:@"image460"];
            }
            break;
            
        case PostTypeAnimated:
            self.thumbnailUrl = [Post URLFromDict:dict andKey:@"image220x145"];
            self.imageUrl = [Post URLFromDict:dict andKey:@"image460sv"];
        default:
            break;
    }

    return self;
}

+(instancetype)postFromDictionary:(NSDictionary *)dict {

    Post *p = [[self alloc] initFromDictionary:(NSDictionary *)dict];
    
    
    return p;
}

-(NSURL *)detailImageUrl {
    if (self.hasLongPostCover) {
        return longPostImageURL;
    }
    return self.imageUrl;
}

+(NSURL *)URLFromDict:(NSDictionary *)dict andKey:(NSString *)key {
    return [NSURL URLWithString:[[[dict[@"images"] objectForKey:key] objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"http" withString:@"https"]];
}

@end

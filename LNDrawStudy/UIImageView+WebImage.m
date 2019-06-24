//
//  UIImageView+WebImage.m
//  LNDrawStudy
//
//  Created by ioser on 2019/4/28.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import "UIImageView+WebImage.h"

@implementation UIImageView (WebImage)

- (NSCache *)imageCahe
{
    static NSCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSCache alloc] init];
    });
    return instance;
}

- (void)setImageWithUrlString:(NSString *)urlStr defaultImage:(UIImage *)defaultImage
{
    if ([[self imageCahe] objectForKey:urlStr]) {
        self.image = [[self imageCahe] objectForKey:urlStr];
    }else{
        self.image = defaultImage;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            UIImage *image = [UIImage imageWithData:data];
            [[self imageCahe] setObject:image forKey:urlStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
        });
    }
}

@end

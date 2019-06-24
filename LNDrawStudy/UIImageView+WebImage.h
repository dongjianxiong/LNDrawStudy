//
//  UIImageView+WebImage.h
//  LNDrawStudy
//
//  Created by ioser on 2019/4/28.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (WebImage)

- (void)setImageWithUrlString:(NSString *)urlStr defaultImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

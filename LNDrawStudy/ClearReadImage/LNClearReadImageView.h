//
//  LNClearReadImageView.h
//  LNDrawStudy
//
//  Created by ioser on 2019/4/12.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNClearReadImageView : UIView

@property (nonatomic, strong) NSArray *imageList;

@property (nonatomic, assign) CGFloat clipWH;

- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END

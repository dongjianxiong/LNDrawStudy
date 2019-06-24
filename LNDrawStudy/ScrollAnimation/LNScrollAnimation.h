//
//  LNScrollAnimation.h
//  LNDrawStudy
//
//  Created by ioser on 2019/4/19.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LNScrollAnimation;
typedef void (^LNImageViewTapAction)(UIView *currentView, NSInteger index, UIImageView *actionImageView);

@interface LNScrollAnimation : UIView

/**
 * 总的视图个数
 */
@property (nonatomic, strong) NSArray *imageUrlList;

/**
 * 点击某个视图时的回调
 */
@property (nonatomic, copy) LNImageViewTapAction tapActionBlock;

- (void)startAnimation;


@end

NS_ASSUME_NONNULL_END

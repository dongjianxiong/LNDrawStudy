//
//  LNBlinkedImageView.h
//  LNDrawStudy
//
//  Created by ioser on 2019/4/12.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNBlinkedImageView : UIView


/**
 * 总的视图个数
 */
@property (nonatomic, strong) NSArray *imageUrlList;

@property (nonatomic, copy) void (^tapAction)(LNBlinkedImageView *blinkedImageView);

- (void)startAnimation;
@end

NS_ASSUME_NONNULL_END

//
//  DJXScrollView.h
//  DJXScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJXScrollView;

typedef void (^DJXContentViewTapAction)(DJXScrollView *scrollView, NSInteger index, UIView *actionView);


@interface DJXScrollView : UIScrollView

/**
 * 总的视图个数
 */
@property (nonatomic, strong) NSArray *imageArr;

/**
 * 点击某个视图时的回调
 */
@property (nonatomic, copy) DJXContentViewTapAction tapActionBlock;

- (void)startAnimation;

@end

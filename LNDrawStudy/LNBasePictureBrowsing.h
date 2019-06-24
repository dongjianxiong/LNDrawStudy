//
//  LNBaaePictureBrowsing.h
//  LNDrawStudy
//
//  Created by ioser on 2019/4/29.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LNPictureBrowsingTapAction)(UIView *currentView, NSInteger index, UIImageView *actionImageView);

@interface LNBasePictureBrowsing : UIView

//图片地址数组
@property (nonatomic, strong) NSArray <NSString *> *imageUrlList;

/**
 * 点击某个视图时的回调
 */
@property (nonatomic, copy) LNPictureBrowsingTapAction tapActionBlock;

- (void)startAnimation;


@end


@interface LNFlashCardAnimationView: LNBasePictureBrowsing

@end

@interface LNShutterAnimationView: LNBasePictureBrowsing

@end

NS_ASSUME_NONNULL_END

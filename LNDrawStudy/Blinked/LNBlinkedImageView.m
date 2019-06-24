//
//  LNBlinkedImageView.m
//  LNDrawStudy
//
//  Created by ioser on 2019/4/12.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import "LNBlinkedImageView.h"
#import "UIImageView+WebImage.h"

@interface LNBlinkedImageView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSMutableArray <UIImageView *> * imageViews;

@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, assign) BOOL animationFinish;

@property (nonatomic, strong) UIView *topFrontView;

@property (nonatomic, strong) UIView *bottomFrontView;

@end

@implementation LNBlinkedImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastIndex = 0;
        self.imageViews = [NSMutableArray array];
        [self creatImageViews];
        self.animationFinish = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)creatImageViews
{
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.bgView];
    
    self.topFrontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    self.topFrontView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.topFrontView];
    
    self.bottomFrontView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    self.bottomFrontView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bottomFrontView];
}

#pragma mark - publick

- (void)startAnimation
{
    if (!self.animationFinish) {
        return;
    }
    self.animationFinish = NO;
    CGRect topStartFrame = CGRectMake(0, 0, self.frame.size.width, 0);
    CGRect bottomStartFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width,0);
    
    CGRect topEndFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2);
    CGRect bottomEndFrame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.topFrontView.frame = topEndFrame;
        weakSelf.bottomFrontView.frame = bottomEndFrame;
    } completion:^(BOOL finished) {
        [weakSelf resetImageView];
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.topFrontView.frame = topStartFrame;
            weakSelf.bottomFrontView.frame = bottomStartFrame;
        } completion:^(BOOL finished) {
            [weakSelf performSelector:@selector(reAnimation) withObject:nil afterDelay:0.5];
        }];
    }];
    
}

- (void)setImageUrlList:(NSArray *)imageUrlList
{
    _imageUrlList = imageUrlList;
    [self.imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageViews removeAllObjects];
    if (imageUrlList.count < 1) {
        return;
    }
    if (imageUrlList.count == 1) {
        UIImageView *imageView = [self imageViewWithUrlStr:imageUrlList[0]];
        [self.bgView  addSubview:imageView];
    }else{
        for (NSInteger index = 0; index < 3; index++) {
            UIImageView *imageView = [self imageViewWithUrlStr:imageUrlList[0]];
            [self.bgView  addSubview:imageView];
            [self.imageViews addObject:imageView];
        }
    }
}

#pragma mark - private

- (UIImageView *)imageViewWithUrlStr:(NSString *)urlStr
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.userInteractionEnabled = YES;
    [imageView setImageWithUrlString:urlStr defaultImage:[self defaultImage]];
    return imageView;
}

- (UIImage *)defaultImage
{
    return [UIImage imageNamed:@"defaultImageBg.png"];
}


- (void)reAnimation
{
    self.animationFinish = YES;
    [self startAnimation];
}

- (void)tapClickAction
{
    if (self.tapAction) {
        self.tapAction(self);
    }
}

- (void)resetImageView
{
    //获取当前图片下标和下一张图片下标
    NSInteger currentIndex = [self indexWithLastIndex:self.lastIndex];
    NSInteger nextIndex = [self indexWithLastIndex:currentIndex];
    //设置当前图片和预设下张图片
    UIImage *defaultImage = [self defaultImage];
    UIImageView *tempImageView = self.imageViews[0];
    [self.imageViews removeObjectAtIndex:0];
    [self.imageViews addObject:tempImageView];
    UIImageView *lastImageView = self.imageViews[2];
    UIImageView *curImageView = self.imageViews[0];
    UIImageView *nextImageView = self.imageViews[1];
    
    [lastImageView setImageWithUrlString:self.imageUrlList[self.lastIndex] defaultImage:defaultImage];
    [curImageView setImageWithUrlString:self.imageUrlList[currentIndex] defaultImage:defaultImage];
    [nextImageView setImageWithUrlString:self.imageUrlList[nextIndex] defaultImage:defaultImage];

    [self.bgView insertSubview:lastImageView belowSubview:nextImageView];
    //记录当前图片下标
    self.lastIndex = currentIndex;
    
}

- (NSInteger)indexWithLastIndex:(NSInteger)lastIndex
{
    NSInteger index = 0;
    if (lastIndex < self.imageUrlList.count - 1) {
        index = lastIndex + 1;
    }else{
        index = 0;
    }
    return index;
}

@end


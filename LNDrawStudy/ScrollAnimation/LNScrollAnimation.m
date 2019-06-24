//
//  LNScrollAnimation.m
//  LNDrawStudy
//
//  Created by ioser on 2019/4/19.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import "LNScrollAnimation.h"
#import "UIImageView+WebImage.h"

const CGFloat LNADSNScrollAnimationImageSpace = 0;

@interface LNScrollAnimation ()

/**
 * imageView数组
 */
@property (nonatomic, strong) NSMutableArray *imageViews;

/**
 * 当前页
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 * 当前页
 */
@property (nonatomic, assign) NSInteger currentImageViewIndex;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) BOOL animationFinish;

@end

@implementation LNScrollAnimation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationFinish = YES;
        self.imageViews = [NSMutableArray array];
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.bgView];
    }
    return self;
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
        UIImageView *imageView = [self imageViewIndex:0];
        [self.bgView  addSubview:imageView];
    }else{
        for (NSInteger index = 0; index < 3; index++) {
            UIImageView *imageView = [self imageViewIndex:index];
            [self.bgView  addSubview:imageView];
            [self.imageViews addObject:imageView];
        }
    }
}

#pragma mark - private

- (UIImageView *)imageViewIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * self.frame.size.width + LNADSNScrollAnimationImageSpace, 0, self.frame.size.width - LNADSNScrollAnimationImageSpace*2, self.frame.size.height)];
    imageView.userInteractionEnabled = YES;
    [imageView setImageWithUrlString:self.imageUrlList[index] defaultImage:[self defaultImage]];
    return imageView;
}

- (UIImage *)defaultImage
{
    return [UIImage imageNamed:@"defaultImageBg.png"];
}


- (void)startAnimation
{
    if (self.imageUrlList.count < 2) {
        return;
    }
    [self performSelector:@selector(animation) withObject:nil afterDelay:1];
}

//获取子视图
- (void)animation
{
    if (!self.animationFinish) {
        return;
    }
    self.animationFinish = NO;
    
    NSInteger currentPage = self.currentPageIndex;
    NSInteger nextPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
    NSInteger nextNextPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex+2];

    UIImage *defaultImage = [self defaultImage];
    //获取将要在中间显示的视图
    UIImageView *curView = self.imageViews[0];
    [curView setImageWithUrlString:self.imageUrlList[currentPage] defaultImage:defaultImage];
    //获取将要在右边显示的视图
    UIImageView *nextView = self.imageViews[1];
    [nextView setImageWithUrlString:self.imageUrlList[nextPage] defaultImage:defaultImage];

    UIImageView *nextNextView = self.imageViews[2];
    [nextNextView setImageWithUrlString:self.imageUrlList[nextNextPage] defaultImage:defaultImage];
    self.currentPageIndex = nextPage;

    CATransform3D transfrom =CATransform3DIdentity;
    CGFloat m34 = 800;
    transfrom.m34 = 1.0 /m34;//透视效果
    CGFloat value = -20;//（控制翻转角度）
    CGFloat radiants= value / 360.0 * 2* M_PI;
    transfrom =CATransform3DRotate(transfrom, radiants,0.0f, 1.0f, 0.0f);//(后面3个数字分别代表不同的轴来翻转，本处为x
    
    CGFloat scale = 0.85;
    CGPoint point = CGPointMake(0.5,0.5);//设定翻转时的中心点，0.5为视图layer的正中
    
    CGRect curViewStartFrame = curView.frame;
    
    CGRect curViewAnimationFrame = curViewStartFrame;
    curViewAnimationFrame.origin.x = -(curViewStartFrame.size.width-LNADSNScrollAnimationImageSpace)/2;
    curViewAnimationFrame.origin.y = curViewStartFrame.origin.y + (curViewStartFrame.size.height - curViewStartFrame.size.height * scale)/2;
    curViewAnimationFrame.size.height = curViewStartFrame.size.height * scale;
    
    CGRect rightViewAnimationFrame = curViewAnimationFrame;
    rightViewAnimationFrame.origin.x = self.frame.size.width/2;
    
    CGRect curViewEndFrame = curViewStartFrame;
    curViewEndFrame.origin.x = -curViewStartFrame.size.width-LNADSNScrollAnimationImageSpace;
    
    CGRect rightViewEndFrame = curViewEndFrame;
    rightViewEndFrame.origin.x = LNADSNScrollAnimationImageSpace;
    
    [UIView animateKeyframesWithDuration:0.9 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.9 * 0.66 animations:^{
            curView.frame = curViewAnimationFrame;
            curView.alpha = 0.5;
            curView.layer.anchorPoint = point;
            curView.layer.transform =  transfrom;
            
            nextView.frame = rightViewAnimationFrame;
            nextView.alpha = 1;
            nextView.layer.anchorPoint = point;
            nextView.layer.transform =  transfrom;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.9 * 0.66 relativeDuration:0.9 * 0.34 animations:^{
            curView.frame = curViewEndFrame;
            curView.alpha = 0;
            curView.layer.anchorPoint = point;
            curView.layer.transform = CATransform3DRotate(transfrom, -radiants, 0.0f, 1.0f, 0.0f);
            
            nextView.frame = rightViewEndFrame;
            nextView.layer.anchorPoint = point;
            nextView.layer.transform = CATransform3DRotate(transfrom, -radiants, 0.0f, 1.0f, 0.0f);
        }];
        
    } completion:^(BOOL finish){
        curView.layer.transform =  CATransform3DRotate(transfrom, 0, 0.0f, 1.0f, 0.0f);;
        curView.frame = CGRectMake(nextView.frame.size.width + LNADSNScrollAnimationImageSpace*2, curView.frame.origin.y, curView.frame.size.width, curView.frame.size.height);
        [self.imageViews addObject:curView];
        [self.imageViews removeObjectAtIndex:0];
        [self performSelector:@selector(reAnimation) withObject:nil afterDelay:1];
    }];
}

- (void)reAnimation
{
    self.animationFinish = YES;
    [self animation];
}

//获取有效下一页
- (NSInteger)validNextPageWithExpectedNextPage:(NSInteger)expectedNextPage
{
    if (expectedNextPage == -1) {
        return self.imageUrlList.count - 1;
    }else if (expectedNextPage == self.imageUrlList.count || expectedNextPage < -1){
        return 0;
    }else if (expectedNextPage > self.imageUrlList.count){
        return self.imageUrlList.count - 1;
    }else{
        return expectedNextPage;
    }
}

@end

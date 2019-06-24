//
//  LNBaaePictureBrowsing.m
//  LNDrawStudy
//
//  Created by ioser on 2019/4/29.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import "LNBasePictureBrowsing.h"
#import "UIImageView+WebImage.h"

const CGFloat SNADSNScrollAnimationImageSpace = 0;

@interface LNBasePictureBrowsing ()

@property (nonatomic, strong) NSMutableArray *imageViews;
/**
 * 当前页
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) BOOL animationFinish;

@end

@implementation LNBasePictureBrowsing

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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.bgView  addSubview:imageView];
    }else{
        [self setupImageViewsWithImageUrls:imageUrlList];
    }
}

#pragma mark - private

- (void)setupImageViewsWithImageUrls:(NSArray *)imageUrls
{

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
    if (!self.animationFinish) {
        return;
    }
    self.animationFinish = NO;
    
    [self performSelector:@selector(animation) withObject:nil afterDelay:1];
}

//获取子视图
- (void)animation
{

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

- (void)resetImageViews
{
    self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
    NSInteger nextPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
    NSInteger nextNextPage = [self validNextPageWithExpectedNextPage:nextPage+1];

    UIImage *defaultImage = [self defaultImage];
    //获取将要在中间显示的视图
    UIImageView *lastView = [self.imageViews firstObject];
    //下一张要显示的图片
    UIImageView *nextView = [self.imageViews lastObject];
    lastView.frame = nextView.frame;//恢复初始状态
    [self.imageViews addObject:lastView];
    [self.imageViews removeObjectAtIndex:0];
    [lastView setImageWithUrlString:self.imageUrlList[nextNextPage] defaultImage:defaultImage];//提前预设下下张图片展示
}
@end

#pragma mark -
@implementation LNFlashCardAnimationView

- (void)setupImageViewsWithImageUrls:(NSArray *)imageUrls
{
    for (NSInteger index = 0; index < 3; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * self.frame.size.width + SNADSNScrollAnimationImageSpace, 0, self.frame.size.width - SNADSNScrollAnimationImageSpace*2, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        [imageView setImageWithUrlString:self.imageUrlList[index] defaultImage:[self defaultImage]];
        [self.bgView  addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
}

- (void)animation
{
    //当前显示的视图
    UIImageView *curView = self.imageViews[0];
    //获取将要在右边显示的视图
    UIImageView *nextView = self.imageViews[1];
    
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
    curViewAnimationFrame.origin.x = -(curViewStartFrame.size.width-SNADSNScrollAnimationImageSpace)/2;
    curViewAnimationFrame.origin.y = curViewStartFrame.origin.y + (curViewStartFrame.size.height - curViewStartFrame.size.height * scale)/2;
    curViewAnimationFrame.size.height = curViewStartFrame.size.height * scale;
    
    CGRect rightViewAnimationFrame = curViewAnimationFrame;
    rightViewAnimationFrame.origin.x = self.frame.size.width/2;
    
    CGRect curViewEndFrame = curViewStartFrame;
    curViewEndFrame.origin.x = -curViewStartFrame.size.width-SNADSNScrollAnimationImageSpace;
    
    CGRect rightViewEndFrame = curViewEndFrame;
    rightViewEndFrame.origin.x = SNADSNScrollAnimationImageSpace;
    
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
        [self resetImageViews];
        [self performSelector:@selector(reAnimation) withObject:nil afterDelay:1];
    }];
}

- (void)resetImageViews
{
    [super resetImageViews];
    UIImageView *lastView = self.imageViews.lastObject;
    lastView.layer.transform =  CATransform3DRotate(CATransform3DIdentity, 0, 0.0f, 1.0f, 0.0f);
    
}


@end

#pragma mark -
@interface LNShutterAnimationView ()

@property (nonatomic, strong) UIView *topFrontView;

@property (nonatomic, strong) UIView *bottomFrontView;

@end

@implementation LNShutterAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topFrontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        self.topFrontView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.topFrontView];
        
        self.bottomFrontView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        self.bottomFrontView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.bottomFrontView];
    }
    return self;
}

- (void)setupImageViewsWithImageUrls:(NSArray *)imageUrls
{
    UIImage *defaultImage = [self defaultImage];
    for (NSInteger index = 2; index >= 0; index--) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.userInteractionEnabled = YES;
        NSInteger validIndex = [self validNextPageWithExpectedNextPage:index];
        [imageView setImageWithUrlString:self.imageUrlList[validIndex] defaultImage:defaultImage];
        [self.bgView  addSubview:imageView];
        [self.imageViews insertObject:imageView atIndex:0];
    }
}

- (void)animation
{
    CGRect topStartFrame = CGRectMake(0, 0, self.frame.size.width, 0);
    CGRect bottomStartFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width,0);
    
    CGRect topEndFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2);
    CGRect bottomEndFrame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.topFrontView.frame = topEndFrame;
        weakSelf.bottomFrontView.frame = bottomEndFrame;
    } completion:^(BOOL finished) {
        [weakSelf resetImageViews];
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.topFrontView.frame = topStartFrame;
            weakSelf.bottomFrontView.frame = bottomStartFrame;
        } completion:^(BOOL finished) {
            [weakSelf performSelector:@selector(reAnimation) withObject:nil afterDelay:0.5];
        }];
    }];
}

- (void)resetImageViews
{
    [super resetImageViews];
    if (self.imageViews.count > 1) {
        UIImageView *lastView = [self.imageViews lastObject];
        UIImageView *nextView = self.imageViews[1];
        [lastView.superview insertSubview:lastView belowSubview:nextView];
    }
}


@end

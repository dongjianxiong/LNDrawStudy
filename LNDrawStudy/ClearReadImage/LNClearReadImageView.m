//
//  LNClearReadImageView.m
//  LNDrawStudy
//
//  Created by ioser on 2019/4/12.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import "LNClearReadImageView.h"

const CGFloat LNOriginclipWH = 60;

@interface LNClearReadImageView ()

@property (nonatomic, strong) UIImageView *presentImageView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation LNClearReadImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipWH = LNOriginclipWH;
        self.lastIndex = 0;
        [self creatImageViews];
    }
    return self;
}

- (void)creatImageViews
{
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgImageView.userInteractionEnabled = YES;
    [self addSubview:self.bgImageView];
    
    self.presentImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.presentImageView.userInteractionEnabled = YES;
    [self addSubview:self.presentImageView];
}

#pragma mark - publick

- (void)startAnimation
{
    if (!self.timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self timerAction];
        }];
        self.timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    self.presentImageView.image = [self imageWithIndex:0];
    self.bgImageView.image = [self imageWithIndex:1];
}

#pragma mark - private

- (void)timerAction
{
    // 获取中心点
    self.clipWH = self.clipWH + self.presentImageView.frame.size.width/2 / 3;
    
    if (self.clipWH >= self.presentImageView.frame.size.width * 2) {
        [self resetImageView];
        return;
    }
    [self clearAnimation];
}

- (void)resetImageView
{
    //擦除干净后重置初始值
    self.clipWH = LNOriginclipWH;
    //交换imageView
    UIImageView *imageView = self.presentImageView;
    self.presentImageView = self.bgImageView;
    self.bgImageView = imageView;
    //前提imageView
    [self bringSubviewToFront:self.presentImageView];
    
    //获取当前图片下标和下一张图片下标
    NSInteger currentIndex = [self indexWithLastIndex:self.lastIndex];
    NSInteger nextIndex = [self indexWithLastIndex:currentIndex];
    
    //设置当前图片和预设下张图片
    self.bgImageView.image = [self imageWithIndex:nextIndex];
    self.presentImageView.image = [self imageWithIndex:currentIndex];
    //记录当前图片下标
    self.lastIndex = currentIndex;
}

- (void)clearAnimation
{
    CGSize imageSize = self.presentImageView.frame.size;
    CALayer *layer = self.presentImageView.layer;
    CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
    CGFloat x = startPoint.x - self.clipWH * 0.5;
    CGFloat y = startPoint.y - self.clipWH * 0.5 * imageSize.height/imageSize.width;
    CGRect rect = CGRectMake(x, y, self.clipWH, self.clipWH * imageSize.height/imageSize.width);
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染控件
    [layer renderInContext:ctx];
    
    //设置成圆角橡皮擦
    CGContextAddEllipseInRect(ctx,rect);
    CGContextClip(ctx);
    //擦除指定区域
    CGContextClearRect(ctx,rect);
    
    //生成一张图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    self.presentImageView.image = image;
    //    self.presentImageView.layer.contents = (__bridge id)image.CGImage;
}

- (NSInteger)indexWithLastIndex:(NSInteger)lastIndex
{
    NSInteger index = 0;
    if (lastIndex < self.imageList.count - 1) {
        index = lastIndex + 1;
    }else{
        index = 0;
    }
    return index;
}

- (UIImage *)imageWithIndex:(NSInteger)index
{
    if (index >= self.imageList.count) {
        return nil;
    }
    UIImage *image = [UIImage imageNamed:self.imageList[index]];
    NSLog(@"image:%@",image);
    return image;
}

@end

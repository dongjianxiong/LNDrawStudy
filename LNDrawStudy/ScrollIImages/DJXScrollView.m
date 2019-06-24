//
//  DJXScrollView.m
//  DJXScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import "DJXScrollView.h"


@interface DJXScrollView ()<UIScrollViewDelegate>

/**
 * 子视图数组
 */
@property (nonatomic, strong) NSMutableArray *contentViews;

/**
 * imageView数组
 */
@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) NSTimer *timer;

/**
 * 当前页
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 * 显示分页标记
 */
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation DJXScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.contentViews = [NSMutableArray array];
        
        NSMutableArray *imageViews = [NSMutableArray array];
        CGRect imageFrame = CGRectMake(10, 0, frame.size.width-20, frame.size.height);
//        CGRect imageFrame = CGRectMake(20, 20, frame.size.width-40, frame.size.height - 40);
        for (int index = 0; index < 3; index ++) {//创建三个imageView用于循环显示图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imageView addGestureRecognizer:tap];
            [imageViews addObject:imageView];
        }
        self.imageViews = imageViews;
        self.delegate = self;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 5, frame.size.width, 30)];
        self.pageControl.pageIndicatorTintColor = [UIColor greenColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
        
    if (_imageArr.count > 0) {
        if (_imageArr.count == 1) {//当只有一张图片的时候不滚动
            self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            self.contentOffset = CGPointMake(0, 0);
            self.scrollEnabled = NO;
        }else{
            //当图片数大于一张时可以滚动
            self.contentSize = CGSizeMake(3*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
            self.scrollEnabled = YES;
        }
        [self configContentView];
    }else{
        [self.contentViews removeAllObjects];
    }
    self.pageControl.numberOfPages = _imageArr.count;
}


- (void)startAnimation
{
    if (!self.timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self timerAction];
        }];
        self.timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerAction
{
    if (self.imageArr.count > 1) {
        [self setContentOffset:CGPointMake(2*CGRectGetWidth(self.frame), 0) animated:YES];
    }
}

//当视图滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= (2*CGRectGetWidth(scrollView.frame))) {
        
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
        [self configContentView];
    }
    if (scrollView.contentOffset.x <= 0) {
        
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
        [self configContentView];
    }
    self.pageControl.currentPage = self.currentPageIndex;
}

//
- (void)configContentView
{
    UIImageView *contentView = nil;
    
    if (self.contentViews.count > 0) {
        contentView = self.contentViews[0];
    }
    [self.contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentViews removeAllObjects];
    
    if (self.imageArr.count == 1) {
        //如果只有一张图片，不需要滚动
        UIImageView *imageView =  self.imageViews[0];
        imageView.image = [UIImage imageNamed:self.imageArr[self.currentPageIndex]];
        [self addSubview:imageView];
        [self.contentViews addObject:imageView];
        
    }else if (self.imageArr.count > 1){
        
        //获取子视图
        [self getContentViewsWithLocations];
        
        //重新对子视图进行布局
        for (int index = 0; index < self.contentViews.count; index++) {
            UIImageView *contentView = self.contentViews[index];
            CGRect contentViewFrame = contentView.frame;
            contentViewFrame.origin.x = index*self.frame.size.width + (self.frame.size.width - contentViewFrame.size.width)/2;
            contentView.frame = contentViewFrame;
            [self addSubview:contentView];
        }
        //视图布局完之后返回到中间的位置
        [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0f) animated:NO];        
    }else{
        NSLog(@"There is no subviews to show");
    }
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self, self.currentPageIndex, tap.view);
    }
}

//获取子视图
- (void)getContentViewsWithLocations
{
    NSInteger leftPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
    NSInteger currentPage = self.currentPageIndex;
    NSInteger rightPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
    
    //获取将要在左边显示的视图
    UIImageView *leftView = self.imageViews[0];
    leftView.image = [UIImage imageNamed:self.imageArr[leftPage]];
    [self.contentViews addObject:leftView];
    
    //获取将要在中间显示的视图
    UIImageView *curView = self.imageViews[1];
    curView.image = [UIImage imageNamed:self.imageArr[currentPage]];
    [self.contentViews addObject:curView];
    
    //获取将要在右边显示的视图
    UIImageView *rightView = self.imageViews[2];
    rightView.image = [UIImage imageNamed:self.imageArr[rightPage]];
    [self.contentViews addObject:rightView];
}


//获取有效下一页
- (NSInteger)validNextPageWithExpectedNextPage:(NSInteger)expectedNextPage
{
    if (expectedNextPage == -1) {
        return self.imageArr.count - 1;
    }else if (expectedNextPage == self.imageArr.count || expectedNextPage < -1){
        return 0;
    }else if (expectedNextPage > self.imageArr.count){
        return self.imageArr.count - 1;
    }else{
        return expectedNextPage;
    }
}

- (void)didMoveToSuperview
{
    [self.superview addSubview:self.pageControl];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

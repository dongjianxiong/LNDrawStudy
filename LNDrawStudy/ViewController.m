//
//  ViewController.m
//  LNDrawStudy
//
//  Created by ioser on 2019/4/10.
//  Copyright © 2019年 Lenny. All rights reserved.
//

#import "ViewController.h"
#import "LNClearReadImageView.h"
#import "LNBlinkedImageView.h"
#import "DJXScrollView.h"
#import "LNScrollAnimation.h"
#import "LNBasePictureBrowsing.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, assign) CGFloat rotation;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageList = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556200895121&di=b868a04d6898f30fadbce6de21b92d9b&imgtype=0&src=http%3A%2F%2Fimg2.ph.126.net%2FbbzrvDdevgaTXj2HK6ajPA%3D%3D%2F6631597730307008033.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556200895121&di=8f809de3585b2749a6ddad71ee262014&imgtype=0&src=http%3A%2F%2Fpic2.52pk.com%2Ffiles%2Fallimg%2F090626%2F1553504U2-2.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556200895121&di=8cbf950480fc538cc00660c816d76bce&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F20182%2F21%2F2018221142159_MZ33z.jpeg"];
//    LNClearReadImageView *animationView = [[LNClearReadImageView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
//    animationView.imageList = imageList;
//    [animationView startAnimation];
//    [self.view addSubview:animationView];
    
//    LNBlinkedImageView *animationView = [[LNBlinkedImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 200)];
//    animationView.imageUrlList = imageList;
//    [animationView startAnimation];
//    [self.view addSubview:animationView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    LNShutterAnimationView *animationView = [[LNShutterAnimationView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 200)];
    animationView.imageUrlList = imageList;
    [animationView startAnimation];
    [self.view addSubview:animationView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    //图片url
//    CGRect scrollViewFrame = CGRectMake(10, 200, self.view.frame.size.width-20, 200);
//    //创建滚动视图
//    DJXScrollView *scrollView = [[DJXScrollView alloc] initWithFrame:scrollViewFrame];
//    scrollView.imageArr = imageList;
//    scrollView.tapActionBlock = ^(DJXScrollView *scrollView, NSInteger index, UIView *actionView){
//        NSLog(@"Tap at %ld", (long)index);
//    };
//
//    scrollView.backgroundColor = [UIColor whiteColor];
//    //设置图片页数
//    [self.view addSubview:scrollView];
//
//    [scrollView startAnimation];
    
    CGRect scrollViewFrame = CGRectMake(10, 250, self.view.frame.size.width - 20, 150);
    //创建滚动视图
    LNScrollAnimation *scrollView = [[LNScrollAnimation alloc] initWithFrame:scrollViewFrame];
    scrollView.imageUrlList = imageList;
    scrollView.tapActionBlock = ^(UIView *scrollView, NSInteger index, UIView *actionView){
        NSLog(@"Tap at %ld", (long)index);
    };
    //设置图片页数
    [self.view addSubview:scrollView];
    [scrollView startAnimation];
    self.animationView = scrollView;
    
    
    LNFlashCardAnimationView *flashCardAnimation = [[LNFlashCardAnimationView alloc] initWithFrame:CGRectMake(10, 410, self.view.frame.size.width - 20, 150)];
    flashCardAnimation.imageUrlList = imageList;
    flashCardAnimation.tapActionBlock = ^(UIView *scrollView, NSInteger index, UIView *actionView){
        NSLog(@"Tap at %ld", (long)index);
    };
    //设置图片页数
    [self.view addSubview:flashCardAnimation];
    [flashCardAnimation startAnimation];
    
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(rotationAnimation) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"animation" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
}

- (void)rotationAnimation
{
//    CGFloat m34 = 800;
//    CGFloat value = -40;//（控制翻转角度）
    CGPoint point = CGPointMake(0.5,0.5);//设定翻转时的中心点，0.5为视图layer的正中
    CATransform3D transfrom =CATransform3DIdentity;
//    transfrom.m34 = 1.0 /m34;
//    self.rotation += 0.1;
    CGFloat radiants= -0.7;//self.rotation;//value / 360.0 * 2* M_PI;
    transfrom =CATransform3DRotate(transfrom, radiants,0.0f, 1.0f, 0.0f);//(后面3个数字分别代表不同的轴来翻转，本处为x轴)
    [UIView animateWithDuration:1 animations:^{
        self.animationView.layer.anchorPoint = point;
        self.animationView.layer.transform = transfrom;
        self.animationView.frame = CGRectMake(-self.view.frame.size.width/2, self.animationView.frame.origin.y, self.animationView.frame.size.width, self.animationView.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.animationView.layer.anchorPoint = point;
            self.animationView.layer.transform = CATransform3DRotate(transfrom, 0.7,0.0f, 1.0f, 0.0f);
            self.animationView.frame = CGRectMake(-self.view.frame.size.width, self.animationView.frame.origin.y, self.animationView.frame.size.width, self.animationView.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
//                self.animationView.layer.anchorPoint = point;
//                self.animationView.layer.transform = CATransform3DRotate(transfrom, 0,0.0f, 1.0f, 0.0f);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];

    
}


@end

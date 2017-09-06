//
//  EasingAnimationViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/8/10.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "EasingAnimationViewController.h"
#import "HYEasing.h"

/**
 * HYEasing 缓动函数 动画的应用
 */
@interface EasingAnimationViewController ()

@end

@implementation EasingAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缓动函数动画";
    // Do any additional setup after loading the view.
    
    UIView *showView         = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    showView.backgroundColor = [UIColor redColor];
    //showView.center          = self.view.center;
    [self.view addSubview:showView];
    
    UIView *showView2         = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    showView2.backgroundColor = [UIColor redColor];
    showView2.center          = self.view.center;
    [self.view addSubview:showView2];
    
    UIView *showView3         = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    showView3.backgroundColor = [UIColor redColor];
    //showView3.center          = self.view.center;
    [self.view addSubview:showView3];
    
    
    [self addAnimationToView:showView];
    [self addPointAnimationToView:showView2];
    [self addSizeAnimationToView:showView3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAnimationToView:(UIView*)view {
    // 计算好起始值,结束值
    CGFloat oldValue = 0.f;
    CGFloat newValue = 1.f;
    
    // 关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设置值
    [animation setValues:[HYEasing calculateFrameFromValue:oldValue
                                                   toValue:newValue
                                                      func:ElasticEaseOut
                                                frameCount:500]];
    
    // 设置持续时间
    animation.duration  = 1.5f;
    
    // 每秒增加的角度(设定结果值,在提交动画之前执行)
    view.layer.transform = CATransform3DMakeRotation(newValue, 0.0, 0.0, 1.0);
    
    // 提交动画
    [view.layer addAnimation:animation forKey:nil];
}

- (void)addPointAnimationToView:(UIView*)view {
    // 计算好起始值,结束值
    CGPoint oldValue = CGPointMake(50, 50);
    CGPoint newValue = self.view.center;//CGPointMake(50, 50);
    
    // 关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 设置值
    [animation setValues:[HYEasing calculateFrameFromPoint:oldValue
                                                   toPoint:newValue
                                                      func:BounceEaseOut
                                                frameCount:500]];
    
    // 设置持续时间
    animation.duration  = 1.5f;
    
    // 每秒增加的角度(设定结果值,在提交动画之前执行)
    view.layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 1.0);
    
    // 提交动画
    [view.layer addAnimation:animation forKey:nil];
}

- (void)addSizeAnimationToView:(UIView*)view {
    // 计算好起始值,结束值
    CGSize oldValue = CGSizeMake(150, 150);
    CGSize newValue = CGSizeMake(100, 100);
    
    // 关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    
    // 设置值
    [animation setValues:[HYEasing calculateFrameFromSize:oldValue
                                                   toSize:newValue
                                                      func:QuadraticEaseOut
                                                frameCount:500]];
    
    // 设置持续时间
    animation.duration  = 1.5f;
    
    // 每秒增加的角度(设定结果值,在提交动画之前执行)
    view.layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 1.0);
    
    // 提交动画
    [view.layer addAnimation:animation forKey:nil];
}

@end

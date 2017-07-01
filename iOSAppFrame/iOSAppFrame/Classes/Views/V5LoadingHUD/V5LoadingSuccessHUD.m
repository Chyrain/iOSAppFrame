//
//  V5LoadingSuccessHUD.m
//  V5LoadingHUDExample
//
//  Created by MengXianLiang on 2017/4/6.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "V5LoadingSuccessHUD.h"

static CGFloat lineWidth = 2.0f;
static CGFloat circleDuration = 0.25f;
static CGFloat checkDuration = .3f;
static CGFloat subCircleDuration = .2f;

#define CircleLineColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]
#define LogoVColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]
#define Logo5Color [UIColor greenColor]//[UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]


@implementation V5LoadingSuccessHUD {
    CALayer *_animationLayer;
}

//显示
+ (V5LoadingSuccessHUD*)showIn:(UIView*)view {
    [self hideIn:view];
    V5LoadingSuccessHUD *hud = [[V5LoadingSuccessHUD alloc] initWithFrame:view.bounds];
    [hud start];
    [view addSubview:hud];
    return hud;
}
//隐藏
+ (V5LoadingSuccessHUD *)hideIn:(UIView *)view {
    V5LoadingSuccessHUD *hud = nil;
    for (V5LoadingSuccessHUD *subView in view.subviews) {
        if ([subView isKindOfClass:[V5LoadingSuccessHUD class]]) {
            [subView hide];
            [subView removeFromSuperview];
            hud = subView;
        }
    }
    return hud;
}

- (void)start {
    [self circleAnimation];
    CGFloat after = 0.2;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, after * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self vpathAnimation];
    });
    dispatch_time_t time1 = dispatch_time(DISPATCH_TIME_NOW, (after + 0.1) * NSEC_PER_SEC);
    dispatch_after(time1, dispatch_get_main_queue(), ^(void){
        [self subCircleAnimation];
    });
}

- (void)hide {
    for (CALayer *layer in _animationLayer.sublayers) {
        [layer removeAllAnimations];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    _animationLayer = [CALayer layer];
    _animationLayer.bounds = CGRectMake(0, 0, 160, 160);
    _animationLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.layer addSublayer:_animationLayer];
}

//画圆
- (void)circleAnimation {
    
    CGFloat lineWidth = 3.0f;
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = _animationLayer.bounds;
    [_animationLayer addSublayer:circleLayer];
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.strokeColor  = CircleLineColor.CGColor;
    circleLayer.lineWidth = lineWidth;
    circleLayer.lineCap = kCALineCapRound;
    
    
    lineWidth = 4.0f;
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleLayer.position radius:radius startAngle:-M_PI_2 endAngle:M_PI+M_PI_2 clockwise:true];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = circleDuration;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [circleLayer addAnimation:checkAnimation forKey:nil];
}

- (void)vpathAnimation {
    CGFloat a = _animationLayer.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //v
//    [path moveToPoint:CGPointMake(a*6/38,a*11/38)];
//    [path addLineToPoint:CGPointMake(a*1/2,a*32.5/38)];
//    [path addLineToPoint:CGPointMake(a*29/38,a*18.5/38)];
//    [path addLineToPoint:CGPointMake(a*22/38,a*20/38)];
//    [path addLineToPoint:CGPointMake(a*1/2,a*23.5/38)];
//    [path addLineToPoint:CGPointMake(a*11.5/38,a*11/38)];
//    [path addLineToPoint:CGPointMake(a*6/38,a*11/38)];
    [path moveToPoint:CGPointMake(a*1/2,a*24/38)];
    [path addLineToPoint:CGPointMake(a*22/38,a*20/38)];
    [path addLineToPoint:CGPointMake(a*29/38,a*18.5/38)];
    [path addLineToPoint:CGPointMake(a*1/2,a*32.5/38)];
    [path addLineToPoint:CGPointMake(a*6/38,a*11/38)];
    [path addLineToPoint:CGPointMake(a*11.5/38,a*11/38)];
    [path addLineToPoint:CGPointMake(a*1/2,a*24/38)];
    [path closePath];
    //5
//    [path moveToPoint:CGPointMake(a*26.7/38,a*16.5/38)];
//    [path addLineToPoint:CGPointMake(a*23/38,a*17.5/38)];
//    [path addLineToPoint:CGPointMake(a*25.5/38,a*13.9/38)];
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = LogoVColor.CGColor;
    checkLayer.lineWidth = lineWidth;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [_animationLayer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = checkDuration;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
}

- (void)subCircleAnimation {
    CGFloat a = _animationLayer.bounds.size.width;
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = _animationLayer.bounds;
    [_animationLayer addSublayer:circleLayer];
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.strokeColor = Logo5Color.CGColor;
    circleLayer.lineWidth = lineWidth;
    circleLayer.lineCap = kCALineCapRound;
    
    CGFloat radius = a*3.6/38;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*23/38,a*17.5/38)];
    [path addLineToPoint:CGPointMake(a*25.4/38,a*14/38)];
//    [path addLineToPoint:CGPointMake(a*26.6/38,a*16.6/38)];
    
    [path moveToPoint:CGPointMake(a*25.4/38,a*14/38)];
    [path addArcWithCenter:CGPointMake(a*29/38,a*13.6/38) radius:radius startAngle:-M_PI-0.1 endAngle:M_PI*2/3+0.13 clockwise:true];
    [path moveToPoint:path.currentPoint];//CGPointMake(a*26.6/38,a*16.6/38)];
    [path addLineToPoint:CGPointMake(a*23/38,a*17.5/38)];
    [path closePath];
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(a*29/38,a*13.6/38) radius:radius startAngle:-M_PI-0.1 endAngle:M_PI*2/3+0.13 clockwise:true];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = subCircleDuration;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [circleLayer addAnimation:checkAnimation forKey:nil];
}

@end

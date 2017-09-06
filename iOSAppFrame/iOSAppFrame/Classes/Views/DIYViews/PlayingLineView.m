//
//  PlayingLineView.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/8/10.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "PlayingLineView.h"
#import "GCD.h"

//将常数转换为度数
#define   DEGREES(degrees)  ((M_PI * (degrees))/ 180.f)

//动画名称
static NSString *AnimationName = @"ESSEQAnimation";

@interface PlayingLineView ()
@property (nonatomic, strong) GCDTimer *timer;
@end

@implementation PlayingLineView
{
    //线宽度
    float _lineWidth;
    //线颜色
    UIColor *_lineColor;
    //线的集合
    NSMutableArray *_layerArr;
    //线的动画
    NSMutableArray *_animationArr;
}
//初始化震动调
-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(27, 66, 128, .5);
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        _layerArr = [NSMutableArray new];
        _animationArr = [NSMutableArray new];
        [self buildLayout];
        [self addCircle];
    }
    return self;
}
//每一个震动条的运动路径
-(NSArray*)values
{
    return @[@[@1.0, @0.5, @0.1, @0.4, @0.7, @0.9, @1.0],
             @[@1.0, @0.8, @0.5, @0.1, @0.5, @0.7, @1.0],
             @[@1.0, @0.7, @0.4, @0.4, @0.7, @0.9, @1.0]];
}
//随机运动的时长
-(NSArray*)durations
{
    return @[@(0.9),@(1.0),@(0.9)];
}

//创建三个竖条
-(void)buildLayout
{
    float margin = (self.bounds.size.width - 3*_lineWidth)/4;
    float height = self.bounds.size.height;
    NSArray* layerHeight = @[@(0.6*height),@(0.8*height),@(0.9*height)];
    for (int i = 0; i < [self values].count; i++) {
        
        
        
        //初始化layer
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineCap = kCALineCapRound;
        layer.strokeColor = _lineColor.CGColor;
        layer.frame = self.bounds;
        layer.lineWidth = _lineWidth;
        [self.layer addSublayer:layer];
        [_layerArr addObject:layer];
        
        //通过贝塞尔曲线设置layer的移动路径
        CGFloat pillarHeight = [layerHeight[i] floatValue];
        CGFloat x = (i+1)*margin + i*_lineWidth;
        CGPoint startPoint = CGPointMake(x, height);
        CGPoint toPoint = CGPointMake(x, height - pillarHeight);
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:toPoint];
        layer.path = path.CGPath;
        
        //设置动画
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        animation.values = [self values][i];
        animation.duration = [[self durations][i] floatValue];
        animation.repeatCount = HUGE_VAL;
        animation.removedOnCompletion = false;//必须设为false否则会被销毁掉
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //[CAMediaTimingFunction functionWithControlPoints:0.55:0.085:0.68:0.53];//[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [layer addAnimation:animation forKey:AnimationName];
        [_animationArr addObject:animation];
    }
}

- (void)addCircle {
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    colorLayer.frame    = self.bounds; //(CGRect){CGPointZero, CGSizeMake(100, 100)};
    //colorLayer.position = self.center;
    [self.layer addSublayer:colorLayer];
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor whiteColor].CGColor,
                          (__bridge id)[UIColor redColor].CGColor];
    colorLayer.locations  = @[@(-0.2), @(-0.1), @(0)];
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0);
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 0);
    
    CAShapeLayer *circle = [PlayingLineView LayerWithCircleCenter:CGPointMake(100, 100)
                                                              radius:80 //(self.bounds.size.width/2 - 10)
                                                          startAngle:DEGREES(0)
                                                            endAngle:DEGREES(360)
                                                           clockwise:YES
                                                     lineDashPattern:nil];
    circle.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:circle];
    circle.strokeEnd = 1.f;
    colorLayer.mask = circle;
    _timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    [_timer event:^{
        
        static int i = 0;
        if (i++ % 2 == 0)
        {
            CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
            fadeAnim.fromValue = @[@(-0.2), @(-0.1), @(0)];
            fadeAnim.toValue   = @[@(1.0), @(1.1), @(1.2)];
            fadeAnim.duration  = 2*NSEC_PER_SEC;
            [colorLayer addAnimation:fadeAnim forKey:nil];
        }
        
    } timeInterval:2*NSEC_PER_SEC];
    [_timer start];
}

+ (CAShapeLayer *)LayerWithCircleCenter:(CGPoint)point
                                 radius:(CGFloat)radius
                             startAngle:(CGFloat)startAngle
                               endAngle:(CGFloat)endAngle
                              clockwise:(BOOL)clockwise
                        lineDashPattern:(NSArray *)lineDashPattern
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:clockwise];
    // 获取path
    layer.path = path.CGPath;
    layer.position = point;
    
    // 设置填充颜色为透明
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 获取曲线分段的方式
    if (lineDashPattern)
    {
        layer.lineDashPattern = lineDashPattern;
    }
    
    return layer;
}

//暂停
-(void)pause
{
    for (int i = 0; i<_layerArr.count; i++) {
        CAShapeLayer *layer = _layerArr[i];
        [layer removeAnimationForKey:AnimationName];
    }
}

//开始
-(void)start
{
    for (int i = 0; i<_layerArr.count; i++) {
        CAShapeLayer *layer = _layerArr[i];
        CAKeyframeAnimation *animation = _animationArr[i];
        [layer addAnimation:animation forKey:AnimationName];
    }
}

@end

//
//  HYArrowView.m
//  mcss
//
//  Created by chyrain on 2017/9/18.
//  Copyright © 2017年 V5KF. All rights reserved.
//

#import "HYArrowView.h"

#define ViewHeight self.bounds.size.height
#define ViewWidth self.bounds.size.width

@interface HYArrowView () {
    //线宽度
    float _lineWidth;
    //线颜色
    UIColor *_lineColor;
    //指向
    BOOL _arrowDown;
    
    CGFloat _startY;
    CGFloat _progress;
}
@property (strong, nonatomic) CADisplayLink *link;
@property (strong, nonatomic) CAShapeLayer *animationLayer;

@end

@implementation HYArrowView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor arrowDown:(BOOL)down
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        _arrowDown = down;
        _duration = 0.35f;
        [self updateArrow];
    }
    return self;
}

- (void)updateArrow {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    if (_arrowDown) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(ViewWidth/2, ViewHeight)];
        [path addLineToPoint:CGPointMake(ViewWidth, 0)];
    } else {
        [path moveToPoint:CGPointMake(0, ViewHeight)];
        [path addLineToPoint:CGPointMake(ViewWidth/2, 0)];
        [path addLineToPoint:CGPointMake(ViewWidth, ViewHeight)];
    }
    self.animationLayer.path = path.CGPath;
}

- (void)arrowUpWithAnimation:(BOOL)animation {
    if (_arrowDown) {
        _arrowDown = false;
        if (animation) {
            _startY = 0;
            _progress = 0;
            self.link.paused = false;
        } else {
            [self updateArrow];
        }
    }
}

- (void)arrowDownWithAnimation:(BOOL)animation {
    if (!_arrowDown) {
        _arrowDown = true;
        if (animation) {
            _startY = ViewHeight;
            _progress = 0;
            self.link.paused = false;
        } else {
            [self updateArrow];
        }
    }
}

#pragma mark - _animationLayer

- (CAShapeLayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.bounds = self.bounds;
        _animationLayer.position = self.center;
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeColor = _lineColor.CGColor;
        _animationLayer.lineWidth = _lineWidth;
        _animationLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_animationLayer];
    }
    return _animationLayer;
}

#pragma mark - CADisplayLink

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link.paused = true;
    }
    return _link;
}

- (void)displayLinkAction {
    _progress += [self speed];
    [self updateAnimationLayer];
    if (_progress >= ViewHeight) {
        self.link.paused = true;
        _progress = 0;
    }
}

- (void)updateAnimationLayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    if (_startY == 0) {
        [path moveToPoint:CGPointMake(0, _startY + _progress)];
        [path addLineToPoint:CGPointMake(ViewWidth/2, ViewHeight - _progress)];
        [path addLineToPoint:CGPointMake(ViewWidth, _startY + _progress)];
    } else {
        [path moveToPoint:CGPointMake(0, _startY - _progress)];
        [path addLineToPoint:CGPointMake(ViewWidth/2, _progress)];
        [path addLineToPoint:CGPointMake(ViewWidth, _startY - _progress)];
    }
    self.animationLayer.path = path.CGPath;
}

- (CGFloat)speed {
    return self.bounds.size.height / (self.duration * 60);
}

@end

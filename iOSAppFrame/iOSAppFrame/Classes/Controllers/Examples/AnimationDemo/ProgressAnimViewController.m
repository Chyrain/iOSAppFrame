//
//  ProgressAnimViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/30.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "ProgressAnimViewController.h"
#import "XLWaveProgress.h"

@interface ProgressAnimViewController () {
    XLWaveProgress *_waveProgress;
    UISlider *_slider;
}

@end

@implementation ProgressAnimViewController


#pragma mark - get & set



#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = LocalStr(@"Progress View", @"Progress View");
    self.view.backgroundColor = [UIColor colorWithRed:78/255.0f green:0/255.0f blue:114/255.0f alpha:1.0f];
    
    _waveProgress = [[XLWaveProgress alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _waveProgress.center = self.view.center;
    _waveProgress.fontSize = 20;
    [self.view addSubview:_waveProgress];
    _waveProgress.progress = 0.0f;
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_waveProgress.frame) + 20, self.view.bounds.size.width - 2*50, 20)];
    [_slider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
    [_slider setMaximumValue:1];
    [_slider setMinimumValue:0];
    [_slider setMinimumTrackTintColor:[UIColor colorWithRed:96/255.0f green:159/255.0f blue:150/255.0f alpha:1]];
    [self.view addSubview:_slider];
}

- (void)onFirstLayoutSubviews {
    _waveProgress.center = self.view.center;
    _slider.frame = CGRectMake(50, CGRectGetMaxY(_waveProgress.frame) + 20, self.view.bounds.size.width - 2*50, 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - selector & action

-(void)sliderMethod:(UISlider*)slider {
    _waveProgress.progress = slider.value;
}


#pragma mark -

- (void)drawCircleInRect {
    //self.view.backgroundColor = [UIColor colorWithRed:78/255.0f green:0/255.0f blue:114/255.0f alpha:1.0f];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGFloat centerX = self.view.center.x;
    CGFloat centerY = self.view.center.y;
    
    UIBezierPath *bezierpath = [UIBezierPath bezierPath];
    [bezierpath moveToPoint:CGPointMake(centerX + 50, centerY)];
    [bezierpath addCurveToPoint:CGPointMake(centerX, centerY - 50) controlPoint1:CGPointMake(centerX + 50, centerY) controlPoint2:CGPointMake(centerX + 50, centerY - 50)];
    [bezierpath addCurveToPoint:CGPointMake(centerX - 50, centerY) controlPoint1:CGPointMake(centerX, centerY - 50) controlPoint2:CGPointMake(centerX - 50, centerY - 50)];
    [bezierpath addCurveToPoint:CGPointMake(centerX, centerY + 50) controlPoint1:CGPointMake(centerX - 50, centerY) controlPoint2:CGPointMake(centerX - 50, centerY + 50)];
    [bezierpath addCurveToPoint:CGPointMake(centerX + 50, centerY - 0.00001) controlPoint1:CGPointMake(centerX, centerY + 50) controlPoint2:CGPointMake(centerX + 50, centerY + 50)];
    
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY - 0.00001)];
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY + 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX - 100, centerY + 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX - 100, centerY - 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY - 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY - 0.00001)];
    
    bezierpath.lineWidth = 1;
    [bezierpath closePath];
    shapeLayer.path = bezierpath.CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
}

@end

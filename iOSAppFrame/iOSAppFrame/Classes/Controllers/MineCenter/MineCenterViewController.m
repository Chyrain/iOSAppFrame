//
//  MineCenterViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "MineCenterViewController.h"
#import "V5LoadingSuccessHUD.h"
#import "V5LoadingHUD.h"
#import "CustomBezierView.h"
#import "PlayingLineView.h"
#import "Masonry.h"
#import "HYEasing.h"
#import "HYArrowView.h"

//宏定义scrollview的宽高
#define view_WIDTH self.view.frame.size.width
#define view_HEIGHT self.view.frame.size.height

@interface MineCenterViewController () {
    PlayingLineView *lineView;
    CALayer *layer1;
    CAGradientLayer *gradientLayer;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) UIBezierPath *trackPath;
@property (strong, nonatomic) CAShapeLayer *trackLayer;
@property (strong, nonatomic) UIBezierPath *progressPath;
@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIView *my_GroupView;
@property (strong, nonatomic) UIView *my_transition;

@property (strong, nonatomic) HYArrowView *arrowView;

@end

@implementation MineCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(222, 222, 222);
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalStr(@"MineCenter", @"我");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始加载" style:UIBarButtonItemStylePlain target:self action:@selector(showLoadingAnimation)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加载完成" style:UIBarButtonItemStylePlain target:self action:@selector(showSuccessAnimation)];
    
//    CustomBezierView *bezierView = [[CustomBezierView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:bezierView];
////    [self setupConstraintsOfView:bezierView];
    
    lineView = [[PlayingLineView alloc] initWithFrame:CGRectMake(view_WIDTH/2 - 100, view_HEIGHT - 300, 200, 200) lineWidth:5 lineColor:[UIColor yellowColor]];
    [self.view addSubview:lineView];
    lineView.hidden = YES;
    self.imageView.hidden = YES;
    
    layer1 = [CALayer layer];
    layer1.frame = CGRectMake(101, 120, 100, 100);
    //设置图层拐角的半径
    //半径是宽度的一半
    layer1.cornerRadius = 100/2;
    layer1.backgroundColor =[UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:layer1];
    
    
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(100, 300, 200, 50);
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(1.0, 0.0)];
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor];
    [self.view.layer addSublayer:gradientLayer];
    gradientLayer.mask = self.textLabel.layer;
    self.textLabel.frame = gradientLayer.bounds;
    
//    NSSet *set;
//    [set sortedArrayUsingDescriptors:nil];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"picture1"]];//图片重复平铺
    
    _arrowView = [[HYArrowView alloc] initWithFrame:CGRectMake(100, 50, 50, 10) lineWidth:2 lineColor:[UIColor blueColor] arrowDown:YES];
    [self.view addSubview:_arrowView];
}

//开始点击时，让视图移动、变形装、颜色，移动的过程视图透明度为0.3
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    layer1.position = [touch locationInView:self.view];
    CGFloat width = CGRectGetWidth(layer1.bounds)!=100?100:50;
    layer1.bounds = CGRectMake(0, 0, width, width);
    layer1.cornerRadius = layer1.cornerRadius!=50?50:0;
    //gradientLayer.bounds = layer1.frame;
    
    CGColorRef color = [UIColor orangeColor].CGColor!=layer1.backgroundColor?[UIColor orangeColor].CGColor:[UIColor colorWithRed:0.865 green:0.585 blue:1.000 alpha:1.000].CGColor;
    layer1.backgroundColor = color;
    //设置透明度
    layer1.opacity = 0.3;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    //取消非rootLayer的隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    //layer的操作...
    layer1.position = [touch locationInView:self.view];
    [CATransaction commit];
}

//移动结束时，视图颜色变正常（不透明）
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    layer1.opacity = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFirstLayoutSubviews {
    lineView.frame = CGRectMake(view_WIDTH/2 - 100, view_HEIGHT - 220, 200, 200);
    
    //[self configLayer];
}

- (void)setupConstraintsOfView:(UIView *)v {
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(40);
        make.centerX.mas_equalTo(self.view);
    }];
}

-(void)showLoadingAnimation{
    self.title = @"正在加载...";
    
//    //隐藏支付完成动画
//    [V5LoadingSuccessHUD hideIn:self.view];
//    //显示支付中动画
//    [V5LoadingHUD showIn:self.view];
    
    [self animationOfTextField:self.textField];
    
    [self animationGroup];
    
    [self animationTransition];
    
    [self.arrowView arrowUpWithAnimation:YES];
}

-(void)showSuccessAnimation{
    self.title = @"加载完成";
    
//    //隐藏支付中成动画
//    [V5LoadingHUD hideIn:self.view];
//    //显示支付完成动画
//    [V5LoadingSuccessHUD showIn:self.view];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(800 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
//        [V5LoadingSuccessHUD hideIn:self.view];
//    });
    
    [self animationPushTransition];
    
    [self.arrowView arrowDownWithAnimation:YES];
}

- (void)configLayer {
    //create mask layer
    
//    CALayer *maskLayer = [CALayer layer];
//    
//    maskLayer.frame = self.imageView.bounds;
//    
//    UIImage *maskImage = [UIImage imageNamed:@"picture0"];
//    
//    maskLayer.contents = (__bridge id)maskImage.CGImage;
//    
//    //apply mask to image layer?
//    
//    self.imageView.layer.mask = maskLayer;
//    self.imageView.layer.shouldRasterize = YES;
//    //self.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    //self.imageView.layer.transform = CATransform3DMakeTranslation(0.5, 1.0, 1.0);
//    
//    self.imageView.image=[UIImage imageNamed:@"picture1"];
    
    
    CGRect mybound = self.view.bounds;
    
    //画两个圆
    [self drawCircleInRect:mybound];
    
    //画虚线
    [self drawDashLineInRect:mybound];
    //画？
    [self drawPathInRect:mybound];
    
    //画一个五边形
    [self fiveAnimation];
    
    //画一个弧线
    [self createCurvedLine];
}

- (void)drawCircleInRect:(CGRect)mybound {
    //外圆
    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:(mybound.size.width - 10)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
    
    _trackLayer = [CAShapeLayer new];
    [self.view.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = nil;
    _trackLayer.strokeColor=[UIColor grayColor].CGColor;
    _trackLayer.path = _trackPath.CGPath;
    _trackLayer.lineWidth=5;
    _trackLayer.frame = mybound;
    
    //内圆
    _progressPath = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:(mybound.size.width - 10)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * 0.7 - M_PI_2 clockwise:YES];
    
    _progressLayer = [CAShapeLayer new];
    [self.view.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = nil;
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.path = _progressPath.CGPath;
    _progressLayer.lineWidth=5;
    _progressLayer.frame = mybound;
}

- (void)drawDashLineInRect:(CGRect)mybound {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blueColor
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:23/255.0 green:23/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 8=线的宽度 4=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:8],
                                    [NSNumber numberWithInt:4],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 5);
    CGPathAddLineToPoint(path, NULL, mybound.size.width, 5);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self.view layer] addSublayer:shapeLayer];
}

- (void)drawPathInRect:(CGRect)mybound {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1.0f] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:4.0f];
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    [shapeLayer setLineCap:kCALineCapButt];
    
//    // Setup the path
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, 0, mybound.size.height/5);
//    CGPathAddLineToPoint(path, NULL, mybound.size.width, mybound.size.height/5);
//    
//    // 8=线的宽度 4=每条线的间距
//    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:8],
//                                        [NSNumber numberWithInt:4],nil]];
    
    UIBezierPath *path = [UIBezierPath new];
    
    [path moveToPoint:CGPointMake(0, 80)];
    [path addLineToPoint:CGPointMake(mybound.size.width, 80)];
    
    CGFloat lengths[] = {18.0, 18.0};
    [path setLineDash:lengths count:2 phase:0];
    
    [shapeLayer setPath:path.CGPath];
    //CGPathRelease(path.CGPath);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self.view layer] addSublayer:shapeLayer];
}

//画一个五边形
-(void)fiveAnimation {
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    //开始点 从上左下右的点
    [aPath moveToPoint:CGPointMake(100,100)];
    //划线点
    [aPath addLineToPoint:CGPointMake(60, 140)];
    [aPath addLineToPoint:CGPointMake(60, 240)];
    [aPath addLineToPoint:CGPointMake(160, 240)];
    [aPath addLineToPoint:CGPointMake(160, 140)];
    [aPath closePath];
//    //设置定点是个5*5的小圆形（自己加的）
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100-5/2.0, 0, 5, 5)];
//    [aPath appendPath:path];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    //设置边框颜色
    shapelayer.strokeColor = [[UIColor redColor]CGColor];
    //设置填充颜色 如果只要边 可以把里面设置成[UIColor ClearColor]
    shapelayer.fillColor = [[UIColor blueColor]CGColor];
    //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
    shapelayer.path = aPath.CGPath;
    [self.view.layer addSublayer:shapelayer];
}

//画一个弧线
-(void)createCurvedLine {
    UIBezierPath *aPath = [UIBezierPath bezierPath];
//    aPath.lineWidth = 5.0;
//    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
//    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(20, 100)];
    [aPath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(70, 0)];
    
    CAShapeLayer *curvedLineLayer = [CAShapeLayer layer];
    curvedLineLayer.lineWidth = 4.0;
    curvedLineLayer.lineCap = kCALineCapRound;//线条拐角
    curvedLineLayer.lineJoin = kCALineJoinRound; //终点处理
    
    curvedLineLayer.strokeColor = [[UIColor blackColor] CGColor];
    curvedLineLayer.fillColor = [UIColor clearColor].CGColor;
    curvedLineLayer.path=aPath.CGPath;
    [self.view.layer addSublayer:curvedLineLayer];
}

- (void)animationOfTextField:(UITextField *)tf {
    //抖动效果
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.values = @[@(0), @(-20), @(0), @(18), @(-16), @(0), @(14), @(0), @(-12), @(0), @(10), @(0), @(-6), @(0), @(3), @(0)];
    animation.duration = .8f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.repeatCount = 1;
    
    [tf.layer addAnimation:animation forKey:@"TextShakeAnimation"];
    //tf.layer.position = self.view.center;
}

-(void)animationGroup
{
    if (self.my_GroupView==nil) {
        self.my_GroupView=[[UIView alloc]initWithFrame:CGRectMake(120,350,50,50)];
        self.my_GroupView.backgroundColor=[UIColor yellowColor];
        [self.view addSubview:self.my_GroupView];
    }
    
    //贝塞尔曲线路径
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:CGPointMake(100.0, 30.0)];
    [movePath addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(300, 200)];
    
    //关键帧动画（位置）
    CAKeyframeAnimation * posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnim.path = movePath.CGPath;
    posAnim.removedOnCompletion = YES;
    
    //缩放动画
//    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
//    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
//    scaleAnim.removedOnCompletion = YES;
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)],
                        [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
    scaleAnim.removedOnCompletion = YES;
    
    //透明动画
//    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
//    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
//    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
//    opacityAnim.removedOnCompletion = YES;
    CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.values = @[@(1.0), @(0.1), @(1.0)];
    opacityAnim.removedOnCompletion = YES;
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:posAnim, scaleAnim, opacityAnim, nil];
    animGroup.duration = 5;
    
    [self.my_GroupView.layer addAnimation:animGroup forKey:nil];
}

//从下往上运动
-(void)animationTransition
{
    //y点就是当要运动后到的Y值
    if (self.my_transition==nil) {
        self.my_transition=[[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-250,[UIScreen mainScreen].bounds.size.width,250)];
        self.my_transition.backgroundColor= RGBACOLOR(12, 12, 211, .5); //[UIColor blueColor];
        [self.view addSubview:self.my_transition];
    }
    self.my_transition.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height-250,[UIScreen mainScreen].bounds.size.width,250);
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.removedOnCompletion = NO;
    //添加动画
    [self.my_transition.layer addAnimation:animation forKey:nil];
}

//从上往下运动
-(void)animationPushTransition
{
    //y点就是当要运动后到的Y值
    if (self.my_transition==nil) {
        self.my_transition=[[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width,250)];
        self.my_transition.backgroundColor= RGBACOLOR(12, 12, 211, .5);//[UIColor blueColor];
        [self.view addSubview:self.my_transition];
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    animation.removedOnCompletion = NO;
    
    //添加动画
    [self.my_transition.layer addAnimation:animation forKey:nil];
    self.my_transition.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width,250);
}

@end

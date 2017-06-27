//
//  GoodsCarViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "GoodsCarViewController.h"

@interface GoodsCarViewController () {
    NSInteger show;
}

@end

@implementation GoodsCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalStr(@"GoodsCar", @"购物车");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"动画" style:UIBarButtonItemStylePlain target:self action:@selector(showAnimation:)];
    show = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showAnimation:(id)sender {
    [self animWithTarget:show ? 0 : 1];
    show = show ? 0 : 1;
}

-(void)animWithTarget:(int)target{
    UIView *view = self.view;
    
    // 1，实例化图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 2,设置图层属性
    // 路径
    CGFloat radius = 2;
    CGFloat margin = 2;
    CGFloat viewWidth = view.bounds.size.width;
    CGFloat viewHeight = view.bounds.size.height;
    // 初始位置
    CGRect rect = CGRectMake(viewWidth/2 - radius - margin, viewHeight, 2 * radius, 2 * radius);
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    layer.path = beginPath.CGPath;
    // 结束位置
    // 结束位置 - 利用缩进，参数为负，是放大矩形，中心点保持不变
    CGFloat maxRadius = sqrt( viewWidth * viewWidth + viewHeight * viewHeight);
    CGRect endRect = CGRectInset(rect, -maxRadius, -maxRadius);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    
    // 提示：一旦设置为 mask 属性，填充颜色无效！
    layer.fillColor = [UIColor yellowColor].CGColor;
    
    [view.layer addSublayer:layer];
    
    self.view.layer.mask = layer;
    //  动画 - 如果要做 shapeLayer 的动画，不能使用 UIView 的动画方法，应该用核心动画
    // 实例化动画对象
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    //设置动画属性
    anim.duration = 0.4;
    if (target == 1) {
        anim.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
        anim.toValue = (__bridge id _Nullable)(endPath.CGPath);
    }else{
        anim.toValue = (__bridge id _Nullable)(beginPath.CGPath);
        anim.fromValue = (__bridge id _Nullable)(endPath.CGPath);
    }
    // 设置向前填充模式
    anim.fillMode = kCAFillModeForwards;
    // 完成之后不删除
    anim.removedOnCompletion = NO;
    // 3> 将动画添加到图层 - ShaperLayer，让哪个图层动画，就应该将动画添加到哪个图层
    [layer addAnimation:anim forKey:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

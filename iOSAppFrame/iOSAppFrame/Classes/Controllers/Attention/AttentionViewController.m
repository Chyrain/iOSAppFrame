//
//  AttentionViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "AttentionViewController.h"
#import "AnimationsTableViewController.h"

static NSString * colCellIdentifier = @"collectCellID";
static CGFloat kCellMagin = 10.f;
static NSString * colHeadIdentifier = @"cxHeadID";

@interface AttentionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@end

@implementation AttentionViewController

#pragma mark - set & get

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (self.view.frame.size.width - 5 * kCellMagin) / 4;
        //设置单元格大小
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth * 0.618);
        //最小行间距(默认为10)
        flowLayout.minimumLineSpacing = 10;
        //最小item间距（默认为10）
        flowLayout.minimumInteritemSpacing = 10;
        //设置senction的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(kCellMagin, kCellMagin, kCellMagin, kCellMagin);
        //设置UICollectionView的滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
        flowLayout.headerReferenceSize = CGSizeMake(0,0);//100,0
        
        //网格布局
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        //注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:colCellIdentifier];
        //注册header
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:colHeadIdentifier];
        //设置数据代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //样式
        _collectionView.backgroundColor = [UIColor colorWithRed:78/255.0f green:0/255.0f blue:114/255.0f alpha:1.0f];
    }
    return _collectionView;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalStr(@"Attention", @"关注");
    self.view.backgroundColor = [UIColor whiteColor];
    
    //右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Animation" style:UIBarButtonItemStylePlain target:self action:@selector(showAnimationViewController)];
    
    // 添加collectionView
    [self.view addSubview:self.collectionView];
    // 贝塞尔曲线画图
    //[self drawCircleInRect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFirstLayoutSubviews {
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - selector

- (void)showAnimationViewController {
    AnimationsTableViewController *animVC = [AnimationsTableViewController loadFromNib];
    [self.navigationController pushViewController:animVC animated:YES];
}

#pragma mark - dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 54;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据identifier从缓冲池里取出cell
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:colCellIdentifier forIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor orangeColor];
    } else {
        cell.backgroundColor = RGBCOLOR(200, 200, 20);//[UIColor yellowColor];
    }
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //kind有两种 一种时header 一种事footer
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:colHeadIdentifier forIndexPath:indexPath];
        header.backgroundColor = UIColorFromRGB(0x1881d3);//[UIColor yellowColor];
        return header;
        
    }
    return nil;
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath section:%ld row:%ld", (long)indexPath.section, (long)indexPath.row);
    
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
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

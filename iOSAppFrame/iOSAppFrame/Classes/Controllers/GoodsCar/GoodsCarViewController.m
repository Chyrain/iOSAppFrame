//
//  GoodsCarViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "GoodsCarViewController.h"
#import "XLImageViewer.h"
#import "ImageCell.h"
#import "SDImageCache.h"
#import "UITools.h"

@interface GoodsCarViewController () <UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger show;
    BOOL isInit;
    UICollectionView *_collectionView;
    NSMutableArray *_imageItems;
}

@end

@implementation GoodsCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = LocalStr(@"GoodsCar", @"购物车");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"动画" style:UIBarButtonItemStylePlain target:self action:@selector(showAnimation:)];
    show = 1;
    
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFirstLayoutSubviews {
    _collectionView.frame = self.view.bounds;
    NSLog(@"self.view.frame:%@ collectionView.frame: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(_collectionView.frame));
}

-(void)buildUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearImageCache)];
    
    NSInteger ColumnNumber = 3;
    CGFloat imageMargin = 10.0f;
    CGFloat itemWidth = (self.view.bounds.size.width - (ColumnNumber + 1)*imageMargin)/ColumnNumber;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
//    _collectionView.contentInset = UIEdgeInsetsMake(0, 6, 0, 6);
    [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

#pragma mark - animation

- (void)showAnimation:(id)sender {
    [self animWithTarget:show ? 0 : 1];
    show = show ? 0 : 1;
}

- (void)animWithTarget:(int)target{
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

#pragma mark - imageUrls

- (NSArray*)imageUrls {
    return @[
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/1.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/2.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/3.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/4.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/5.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/6.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/7.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/8.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/9.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/10.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/11.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/12.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/1.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/2.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/3.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/4.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/5.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/6.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/7.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/8.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/9.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/10.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/11.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/12.png"];
}

#pragma mark CollectionViewDelegate&DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self imageUrls].count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"ImageCell";
    ImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0f;
    cell.imageUrl = [self imageUrls][indexPath.row];
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //利用XLImageViewer显示网络图片
    [[XLImageViewer shareInstanse] showNetImages:[self imageUrls] index:indexPath.row fromImageContainer:[collectionView cellForItemAtIndexPath:indexPath]];
}

-(void)clearImageCache {
    [UITools showActionSheetWithMessage:@"删除本地图片缓存？" destructiveTitle:@"删除" destructiveBlock:^{
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [_collectionView reloadData];
        }];
    } inViewController:self];
}


@end

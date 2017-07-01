//
//  HostViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HostViewController.h"
#import "HostCollectionViewCell.h"
#import "HostHeaderCollectionReusableView.h"
#import "HYSearchBar.h"

#define BannerHeight 160
//宏定义scrollview的宽高
#define view_WIDTH self.view.frame.size.width
#define view_HEIGHT self.view.frame.size.height

static NSString * hostCellIdentifier = @"hyCellID";
static NSString * hostHeaderIdentifier = @"hyHeaderID";

@interface HostViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HostHeadCollectionReusableViewDelegete, HYSearchBarDelegate> {
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) HYSearchBar *searchBar;
@end

@implementation HostViewController

#pragma mark - set_and_get

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWH = (view_WIDTH - 1) / 2; // 设置item尺寸
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH + 20);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 设置滚动方向
        flowLayout.minimumLineSpacing = 1;        // 设置最小行间距
        flowLayout.minimumInteritemSpacing = 1;   // 设置最小item间距
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -64, view_WIDTH, view_HEIGHT - 49) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = RGBACOLOR(238, 238, 238, 1);
        [_collectionView registerClass:[HostCollectionViewCell class] forCellWithReuseIdentifier:hostCellIdentifier]; // 注册cell
        // 注册UICollectionReusableView即headerView（切记要添加headerView一定要先注册）
        [_collectionView registerClass:[HostHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hostHeaderIdentifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];  // KVO 添加监听者,用于导航栏偏移改变透明度
    }
    return _collectionView;
}

- (HYSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[HYSearchBar alloc] initWithFrame:CGRectMake(10, 0, view_WIDTH - 20, 44) withShowCancelBtn:NO];
        _searchBar.searchBarDelegate = self;
    }
    return _searchBar;
}

- (NSArray *)dataArray
{
    return @[@{@"icon":@"picture%ld",
               @"describe":@"进口美妆 正品保障",
               @"currentPrice":@"98",
               @"originalPrice":@"128"}];
}

#pragma mark - life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.title = LocalStr(@"Host", @"首页");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.tintColor = NavTintColor; // 字体颜色
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.navigationController.navigationBar setValue:@(0.1) forKeyPath:@"backgroundView.alpha"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // 移除监听
    [_collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - 监听goodsTableView的contentOffset属性值发生改变时回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat offset = _collectionView.contentOffset.y;
    CGFloat delta = MAX(0, (offset - 160) / 160*ScreenScaleY + 1.f);
    self.searchBar.searchBarTextField.backgroundColor = RGBACOLOR(233.f, 233.f, 233.f, MAX(0.6, delta));
    [self.navigationController.navigationBar setValue:@(MIN(0.9, delta)) forKeyPath:@"backgroundView.alpha"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 80;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hostCellIdentifier forIndexPath:indexPath];
    [self dataForCell:cell atIndexPath:indexPath];
    return cell;
}

// 辅助cell填充
- (void)dataForCell:(HostCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self dataArray][0];
    cell.iconName = [NSString stringWithFormat:@"picture%ld", indexPath.row%7];
    cell.describe = item[@"describe"];
    cell.currentPrice = item[@"currentPrice"];
    cell.originalPrice = item[@"originalPrice"];
}

#pragma mark - 添加headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HostHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hostHeaderIdentifier forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionHeader) { // 判断上面注册的UICollectionReusableView类型
        headerView.delegate = self;
        return headerView;
    } else {
        return nil;
    }
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Host collectionView didSelectItemAtIndexPath section:%ld row:%ld", (long)indexPath.section, (long)indexPath.row);
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 380); // 设置headerView的宽高
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(14, 0, 0, 0); //设置collectionView的cell上、左、下、右的间距
}


#pragma mark - HostHeadCollectionReusableViewDelegete
/**
 * carouselView
 * @param indexItem index item
 */
- (void)hostHeaderScrollViewEventDidSelectIndex:(NSInteger)indexItem {
    NSLog(@"Host HeaderScrollView didSelectIndex:%ld", (long)indexItem);
}

/**
 * hostHeadCollection
 * @param indexItem index item
 */
- (void)hostHeaderCollectionEventDidSelectIndex:(NSInteger)indexItem {
    NSLog(@"Host HeaderCollectionView didSelectIndex:%ld", (long)indexItem);
}

@end

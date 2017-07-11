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
#import "HostCollectionViewFlowLayout.h"
#import "HYSearchBar.h"
#import "HostSearchViewController.h"

//宏定义scrollview的宽高
#define view_WIDTH self.view.frame.size.width
#define view_HEIGHT self.view.frame.size.height
#define view_BG_COLOR RGBCOLOR(232, 232, 232)
#define searchView_Anim_Duration 0.35

static NSString * hostCellIdentifier = @"hyCellID";
static NSString * hostHeaderIdentifier = @"hyHeaderID";

@interface HostViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HostHeadCollectionReusableViewDelegete, HYSearchBarDelegate, HostSearchViewDelegate> {
    HostSearchViewController *hotWordSearchViewController;
    BOOL inited;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) HYSearchBar *searchBar;
@end

@implementation HostViewController

#pragma mark - set_and_get

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //自动网格布局，HostCollectionViewFlowLayout内部实现拉伸放大效果
        HostCollectionViewFlowLayout *flowLayout = [[HostCollectionViewFlowLayout alloc] init];
        CGFloat itemWH = (view_WIDTH - 1) / 2; // 设置item尺寸
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, HOST_COLLECTION_HERDER_H);
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH + 20);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 设置滚动方向
        flowLayout.minimumLineSpacing = 1;        // 设置最小行间距
        flowLayout.minimumInteritemSpacing = 1;   // 设置最小item间距
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -kStatusAndTopBarHeight, view_WIDTH, view_HEIGHT - kBottomBarHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = view_BG_COLOR;
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
    self.view.backgroundColor = view_BG_COLOR;
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.tintColor = NavTintColor; // 字体颜色
    if (!inited) {
        inited = YES;
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
            self.navigationController.navigationBar.translucent = YES;
            [self.navigationController.navigationBar setValue:@(0.1) forKeyPath:@"backgroundView.alpha"];
        } completion:^(BOOL finished) {
            if (finished) {
                [self updateNavigationBarAlpha];
            }
        }];
    }
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
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self updateNavigationBarAlpha];
    }
}

- (void)updateNavigationBarAlpha {
    CGFloat offset = _collectionView.contentOffset.y;
    CGFloat delta = MAX(0, (offset - 160) / 160*ScreenScaleY + 1.f);
    self.searchBar.searchBarTextField.backgroundColor = RGBACOLOR(233.f, 233.f, 233.f, MAX(0.6, delta));
    [self.navigationController.navigationBar setValue:@(MIN(0.8, delta)) forKeyPath:@"backgroundView.alpha"];
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
    cell.iconName = [NSString stringWithFormat:@"picture%zi", indexPath.row%6];
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

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //set color with animation
    [UIView animateWithDuration:0.1
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1]];
                     }
                     completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //set color with animation
    [UIView animateWithDuration:0.1
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor whiteColor]];
                     }
                     completion:nil ];
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 下拉伸展放大的header不设置headerView的宽高
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(self.view.bounds.size.width, 380); // 设置headerView的宽高
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 0, 0, 0); //设置collectionView的cell上、左、下、右的间距
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

#pragma mark - UISearchBarDelegate 代理方法
/**
 * 语音识别回调
 * @param resultStr 返回语音搜索关键字
 */
- (void)hy_onVoiceResult:(NSString *)resultStr {
    NSLog(@"hy_onVoiceResult:%@", resultStr);
}

/**
 * 取消事件
 */
- (void)hy_searchBarCancelButtonClicked:(UISearchBar *)searchBar   // called when cancel button pressed
{
    NSLog(@"hy_searchBarCancelButtonClicked");
    if ([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
    [self onSearchViewControllerDismiss];
}

/**
 * 搜索框中右端事件
 */
- (void)hy_searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"hy_searchBarBookmarkButtonClicked");
}

/**
 * 搜索事件
 */
- (void)hy_searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"hy_searchBarSearchButtonClicked: %@", searchBar.text);
    //提交搜索
}

/**
 * 搜索框内容变化时回调
 * @param result 输入框内容
 */
- (void)hy_searchBarSearchResult:(NSString *) result {
    NSLog(@"hy_searchBarSearchResult: %@", result);
    //实时输入值
}

/**
 * 激活搜索框
 * @param searchBar 搜索框
 * @return 是否激活
 */
- (BOOL)hy_searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"hy_searchBarShouldBeginEditing");
    [self.searchBar setShowsCancelButton:YES animated:YES];
    //隐藏TabBar
    //[self.tabBarController.tabBar setHidden:YES];//////
    
    if (!hotWordSearchViewController) {
        hotWordSearchViewController = [[HostSearchViewController alloc] initWithViewControllerName:@"HostViewController"];
        hotWordSearchViewController.delegate = self;
        [self addChildViewController:hotWordSearchViewController];
        [self.view addSubview:hotWordSearchViewController.view];
        hotWordSearchViewController.view.frame = self.view.bounds;
        hotWordSearchViewController.view.alpha = 0;
        [UIView transitionWithView:self.view
                          duration:searchView_Anim_Duration
                           options:UIViewAnimationOptionCurveEaseIn //any animation
                        animations:^ {
                            hotWordSearchViewController.view.alpha = 0.96;
                        }
                        completion:nil];
    }
    //[self.view addSubview:hotWordSearchViewController.view];
    return YES;
}

#pragma mark - HostSearchViewDelegate方法,搜索页取消时移除当前视图
- (void)onSearchViewControllerDismiss
{
    NSLog(@"onSearchViewControllerDismiss");
    [self.searchBar setShowsCancelButton:NO animated:YES];
    //恢复导航栏颜色样式
    [UIView animateWithDuration:searchView_Anim_Duration animations:^{
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = YES;
        hotWordSearchViewController.view.alpha = 0;
        [self updateNavigationBarAlpha];
    }];
    //显示TabBar
    //[self.tabBarController.tabBar setHidden:NO];
    
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController isKindOfClass:[HostSearchViewController class]]) {
            [viewController willMoveToParentViewController:self];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    hotWordSearchViewController.delegate = nil;
    hotWordSearchViewController = nil;
}

#pragma mark - 搜索页传过来的keyWord
- (void)hotWordSearchSelect:(NSString *)hotWordString
{
    NSLog(@"hotWordSearchSelect: %@", hotWordString);
    //提交搜索
    
    //[self onSearchViewControllerDismiss];
    
    //    NSString *keyWordString = [NSString stringWithFormat:@"keywords=%@&", hotWordString];
    
    //    B2CShoppingListViewController *filterProductListViewController = [[B2CShoppingListViewController alloc] initWithChannelIdOrKeyWord:keyWordString];
    //    filterProductListViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:filterProductListViewController animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
    
}

@end

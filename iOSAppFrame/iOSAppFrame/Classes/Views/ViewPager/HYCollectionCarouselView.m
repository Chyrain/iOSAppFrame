//
//  HYCollectionCarouselView.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYCollectionCarouselView.h"
#import "HYCarouselViewCell.h"

static NSString *carouselCellId = @"carouselCollectionViewCell";

@interface HYCollectionCarouselView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation HYCollectionCarouselView

#pragma mark - init & life
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    self = [super init];
    if (self) {
        self.autoPlayTime = 3.0;
        //自动网格布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = frame.size; // 设置item尺寸
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 设置滚动方向
        flowLayout.minimumLineSpacing = 0; // 设置最小行间距
        flowLayout.minimumInteritemSpacing = 0; // 设置最小item间距
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [collectionView registerClass:[HYCarouselViewCell class] forCellWithReuseIdentifier:carouselCellId];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES; // 设置分页
        collectionView.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
        [self addSubview:collectionView];
        
        self.collectionView = collectionView;
        self.imageArray = imageArray;
        
        [self addSubview:self.pageControl]; // 添加分页器
        
        // 回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [self addTimer]; // 添加定时器
        });
    }
    return self;
}

- (void)dealloc
{
    [self removeTimer];
}

#pragma mark: 懒加载pageControl
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 170, 0, 30)];
        _pageControl.numberOfPages = self.imageArray.count;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:82.0/255.0 green:157.0/255.0 blue:219.0/255.0 alpha:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:carouselCellId forIndexPath:indexPath];
    cell.imageName = self.imageArray[indexPath.item % self.imageArray.count];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegete respondsToSelector:@selector(hy_collectionCarouselViewDidSelectItem:)]) {
        [self.delegete hy_collectionCarouselViewDidSelectItem:(indexPath.item % self.imageArray.count)];
    }
}

#pragma mark: 开始拖时调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark: 当滚动减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / scrollView.bounds.size.width;
    if (page == 0) {
        page = self.imageArray.count;
        self.collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0);
    } else if (page == [self.collectionView numberOfItemsInSection:0] - 1) {
        page = self.imageArray.count - 1;
        self.collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0);
    }
    NSInteger currentPage = page % self.imageArray.count; // 设置UIPageControl当前页
    self.pageControl.currentPage =currentPage;
    [self addTimer]; // 添加定时器
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer]; // 移除定时器
}

#pragma mark: 添加定时器
- (void)addTimer
{
    if (self.timer) return;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoPlayTime target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark: 移除定时器
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark: 切换到下一张图片
- (void)nextImage
{
    CGFloat offsetX = self.collectionView.contentOffset.x;
    NSInteger page = offsetX / self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake((page + 1) * self.collectionView.bounds.size.width, 0) animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

@end

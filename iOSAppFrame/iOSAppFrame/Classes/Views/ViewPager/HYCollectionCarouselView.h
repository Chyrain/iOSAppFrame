//
//  HYCollectionCarouselView.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^hy_didClickPagerIndexCallBack) (NSInteger index);
@protocol HYCollectionCarouselViewDelegete <NSObject>
/**
 * selected item
 * @param indexItem index item
 */
- (void)hy_collectionCarouselViewDidSelectItem:(NSInteger )indexItem;

@end

@interface HYCollectionCarouselView : UIView
//点击图片回调的block
@property (nonatomic, copy) hy_didClickPagerIndexCallBack clickBlcok;
//点击图片回调的delegate（与block二选一，优先处理block）
@property (nonatomic, weak) id<HYCollectionCarouselViewDelegete> delegete;
@property (nonatomic, assign) NSTimeInterval autoPlayTime;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  创建轮播器的构造方法
 *
 *  @param frame         轮播器的frame
 *  @param imageArray   轮播器图片的数据源 [{@"网络图片URL", @"UIImage对象"}]
 *
 *  @return 返回一个轮播器组件
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;
//停止定时器
- (void)stopTimer;
//开启定时器
- (void)startTimer;
@end

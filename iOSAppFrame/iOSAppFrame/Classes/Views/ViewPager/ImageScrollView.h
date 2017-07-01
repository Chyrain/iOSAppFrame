//
//  ImageScrollView.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didClickPagerIndexCallBack) (NSInteger index);

@interface ImageScrollView : UIView
//点击图片回调的block
@property (nonatomic, copy) didClickPagerIndexCallBack clickBlcok;
//scrollView
@property(nonatomic, strong) UIScrollView * scrollView;
//pageControl
@property(nonatomic, strong) UIPageControl *pageControl;

/**
 *  创建轮播器的构造方法
 *
 *  @param frame         轮播器的frame
 *  @param playTime      轮播器图片的切换时间
 *  @param imagesArray   轮播器图片的数据源 [{@"image": @"本地图片路径", @"url": @"网络图片url"}]
 *  @param clickCallBack 点击轮播器imageview回调的block
 *
 *  @return 返回一个轮播器组件
 */
- (instancetype)initViewWithFrame:(CGRect)frame
                     autoPlayTime:(NSTimeInterval)playTime
                      imagesArray:(NSArray *)imagesArray
                    clickCallBack:(didClickPagerIndexCallBack)clickCallBack;
@end

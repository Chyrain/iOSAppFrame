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
//轮播器图片的切换时间,默认5s
@property (nonatomic, assign) NSTimeInterval autoPlayTime;

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

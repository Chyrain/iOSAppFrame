//
//  HYTabBar.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/3.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTabBar;

@protocol HYTabBarDelegate <NSObject>
@optional
- (void)hy_tabBarCenterBtnClick:(HYTabBar *)tabBar;
@end

@interface HYTabBar : UITabBar
@property (nonatomic, strong) UIButton *centerBtn;
// hy_delegate为空时默认开启对应index的ViewController，不为空时自定义点击后的动作
@property (nonatomic, weak) id<HYTabBarDelegate> hy_delegate;

- (instancetype)initWithFrame:(CGRect)frame andTabVC:(UITabBarController *)tabVC;

@end

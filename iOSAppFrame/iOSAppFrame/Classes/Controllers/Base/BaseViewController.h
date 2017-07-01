//
//  BaseViewController.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//左右导航按钮回调
typedef void(^PassAction)(UIButton *button);

//刷新按钮回调
typedef void(^RefreshAction)();

//传值回调
typedef void(^PassStr)(NSString *);

@interface BaseViewController : UIViewController

@property (copy, nonatomic) PassAction leftItemAction;
@property (copy, nonatomic) PassAction rightItemAction;
@property (copy, nonatomic) RefreshAction refreshAction;
@property (copy, nonatomic) PassStr passStr;


#pragma mark - NavigationBar

/**
 * 首次LayoutView，用于更新子view的frame
 */
- (void)onFirstLayoutSubviews;

//- (void)setNavigationBarTitle:(NSString *)title;
//
///**
// *  设置navigation背景透明
// */
//- (void)setNavigationBackGroudDiaphanous;
//
///**
// *  设置navigation背景不透明
// */
//- (void)setNavigationBackGroudOpaque;
//
///**
// *  设置navigation左按钮（图片）
// *
// *  @param image     normal图片
// *  @param highImage 高亮图片
// */
//- (void)setNavigationBarLeftItemimage:(NSString *)image highImage:(NSString *)highImage;
//
///**
// *  设置navigation左按钮（文字）
// *
// *  @param title 按钮文字
// */
//- (void)setNavigationBarLeftItemButttonTitle:(NSString *)title;
//
///**
// *  设置navigation左按钮（图片 + 文字）
// *
// *  @param title 文字
// *  @param image 图片
// */
//- (void)setNavigationBarLeftItemButtonTitle:(NSString *)title image:(NSString *)image;
//
///**
// *  设置navigation右按钮
// *
// *  @param image     正常图片
// *  @param highImage 高亮图片
// */
//- (void)setNavigationBarRightItemimage:(NSString *)image highImage:(NSString *)highImage;
///**
// *  设置navigation右按钮（文字）
// *
// *  @param title 按钮文字
// */
//- (void)setNavigationBarRightItemButttonTitle:(NSString *)title;
//
///**
// *  设置navigation右按钮（图片 + 文字）
// *
// *  @param title 文字
// *  @param image 图片
// */
//- (void)setNavigationBarRightItemButtonTitle:(NSString *)title image:(NSString *)image;

@end

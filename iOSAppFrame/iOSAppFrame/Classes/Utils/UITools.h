//
//  UITools.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITools : NSObject

#pragma mark -

// AlertView
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelbtn inViewController:(UIViewController *)vc;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelbtn otherTitle:(NSString *)otherBtn otherBlock:(void (^)(void))otherBlock inViewController:(UIViewController *)vc;
// ActionSheet
+ (void)showActionSheetWithCopyTitle:(NSString *)copyTitle copyBlock:(void (^)(void))copyBlock otherTitle:(NSString *)otherTitle otherBlock:(void (^)(void))otherBlock inViewController:(UIViewController *)vc;

#pragma mark -
/**
 * 显示Toast提示
 */
+ (void)showToast:(nonnull NSString *)text;
+ (void)showToast:(nonnull NSString *)str inView:(nonnull UIView *)view;

#pragma mark -
/**
 *  获得正在显示的VC
 *
 *  @return UIViewController
 */
+ (UIViewController * _Nullable)getCurrentVC;

/**
 *  获得当前屏幕中present出来的VC
 *
 *  @return UIViewController
 */
+ (UIViewController * _Nullable)getPresentedVC;

#pragma mark -
/**
 * 打开浏览器
 */
+ (BOOL)openURL:(NSURL *)url;
/**
 * 打电话
 */
+ (BOOL)openTel:(NSString *)tel;

#pragma mark -
/**
 * view旋转动画
 */
+ (void)rotateView:(UIView *)view angle:(CGFloat)angle;

// 图片去色变灰
+ (nonnull UIImage *)grayImage:(UIImage *)sourceImage;

/**
 设置View四个角任意角的圆角
 */
+ (void)cornerRadiusForView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 * 获取纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

//关闭键盘
+ (void)closeKeyboard;

/******* UITableView Utils *******/
+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message;
+ (UIView *)tableViewsFooterView;

// 无标题返回按钮
+ (UIBarButtonItem *)navigationBackButtonWithNoTitle;

@end

NS_ASSUME_NONNULL_END

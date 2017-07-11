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
+ (void)showActionSheetWithMessage:(NSString *)title destructiveTitle:(NSString *)destructiveTitle destructiveBlock:(void (^)(void))destructiveBlock inViewController:(UIViewController *)vc;

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

//关闭键盘
+ (void)closeKeyboard;

/******* UITableView Utils *******/
+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message;
+ (UIView *)tableViewsFooterView;

// 无标题返回按钮
+ (UIBarButtonItem *)navigationBackButtonWithNoTitle;

#pragma mark - UIImage
/**
 * 获取纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
// 将一个 view 进行截图
+ (UIImage *)snapImageForView:(UIView *)view;

#pragma mark - Color
//字符串#ffffff转UIColor
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
//随机颜色
+ (UIColor *)randomColor;

#pragma mark -
/**
 * 字体size
 */
+ (CGFloat)adjustWithFont:(UIFont *)font WithString:(NSString *)string WithSize:(CGSize)size;
+ (CGSize)adjustWithFont:(UIFont*)font WithText:(NSString *)string WithSize:(CGSize)size;

+ (BOOL)validateString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END

//
//  UITools.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "UITools.h"
#import "AlertController.h"
#import "Macros.h"
#import "MBProgressHUD.h"

@implementation UITools

#pragma mark -Toast

+ (void)showToast:(NSString *)text {
    UIView *view = [UITools getCurrentVC].view;
    if (!view) {
        return;
    }
    __block MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    //    hud.labelText = text;
    hud.detailsLabelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = -160.0f;
    hud.margin = 10.0;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
        hud = nil;
    }];
}

/**
 *  显示提示信息
 *
 *  @param str 提示内容
 */
+ (void)showToast:(NSString *)str inView:(UIView *)view {
    __block MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    //    hud.labelText = str;
    hud.detailsLabelText = str;
    hud.mode = MBProgressHUDModeText;
    hud.opacity = 0.8;
    hud.dimBackground = NO;
    hud.yOffset = -(Main_Screen_Height - 200)/2;//-160.0f;
    hud.color = RGBACOLOR(98, 98, 98, 0.9);
    hud.margin = 10.0;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
        hud = nil;
    }];
}

#pragma mark -

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelbtn inViewController:(nonnull UIViewController *)vc {
    AlertController *alert = [AlertController alertControllerWithTitle:title message:message preferredStyle:AlertControllerStyleAlert];
    AlertAction *cancelAction = [AlertAction actionWithTitle:cancelbtn style:AlertActionStyleCancel handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"cancel button pressed");
    }];
    [alert addAction:cancelAction];
    [vc presentAlertController:alert animated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelbtn otherTitle:(NSString *)otherBtn otherBlock:(void (^)(void))otherBlock inViewController:(UIViewController *)vc {
    AlertController *alert = [AlertController alertControllerWithTitle:title message:message preferredStyle:AlertControllerStyleAlert];
    AlertAction *cancelAction = [AlertAction actionWithTitle:cancelbtn style:AlertActionStyleCancel handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"cancel button pressed");
    }];
    [alert addAction:cancelAction];
    AlertAction *otherAction = [AlertAction actionWithTitle:otherBtn style:AlertActionStyleDefault handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"other button pressed");
        if (otherBlock) {
            otherBlock();
        }
    }];
    [alert addAction:otherAction];
    [vc presentAlertController:alert animated:YES completion:nil];
}

/**
 * ActionSheet的使用示例，具体按钮添加可完全自定义
 */
+ (void)showActionSheetWithCopyTitle:(NSString *)copyTitle copyBlock:(void (^)(void))copyBlock otherTitle:(NSString *)otherTitle otherBlock:(void (^)(void))otherBlock inViewController:(UIViewController *)vc {
    AlertController *alert = [AlertController alertControllerWithTitle:nil message:nil preferredStyle:AlertControllerStyleActionSheet];
    AlertAction *cancelAction = [AlertAction actionWithTitle:LocalStr(@"cancel", @"取消") style:AlertActionStyleCancel handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"cancel button pressed");
    }];
    [alert addAction:cancelAction];
    AlertAction *copyAction = [AlertAction actionWithTitle:copyTitle style:AlertActionStyleDefault handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"copy button pressed");
        if (copyBlock) {
            copyBlock();
        }
    }];
    [alert addAction:copyAction];
    AlertAction *otherAction = [AlertAction actionWithTitle:otherTitle style:AlertActionStyleDefault handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"other button pressed");
        if (otherBlock) {
            otherBlock();
        }
    }];
    [alert addAction:otherAction];
    [vc presentAlertController:alert animated:YES completion:nil];
}

/**
 * ActionSheet的使用示例，具体按钮添加可完全自定义
 */
+ (void)showActionSheetWithMessage:(NSString *)title destructiveTitle:(NSString *)destructiveTitle destructiveBlock:(void (^)(void))destructiveBlock inViewController:(UIViewController *)vc {
    AlertController *alert = [AlertController alertControllerWithTitle:nil message:title preferredStyle:AlertControllerStyleActionSheet];
    AlertAction *cancelAction = [AlertAction actionWithTitle:LocalStr(@"cancel", @"取消") style:AlertActionStyleCancel handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"cancel button pressed");
    }];
    [alert addAction:cancelAction];
    AlertAction *otherAction = [AlertAction actionWithTitle:destructiveTitle style:AlertActionStyleDestructive handler:^(AlertAction *action) {
        // handle cancel button action
        NSLog(@"other button pressed");
        if (destructiveBlock) {
            destructiveBlock();
        }
    }];
    [alert addAction:otherAction];
    [vc presentAlertController:alert animated:YES completion:nil];
}

#pragma mark -

/**
 *  获得正在显示的VC
 *
 *  @return UIViewController
 */
+ (UIViewController *)getCurrentVC {
    UIViewController *resultVC = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmp in windows) {
            if (tmp.windowLevel == UIWindowLevelNormal) {
                window = tmp;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        resultVC = nextResponder;
    } else {
        resultVC = window.rootViewController;
    }
    
    return resultVC;
}

/**
 *  获得当前屏幕中present出来的VC
 *
 *  @return UIViewController
 */
+ (UIViewController *)getPresentedVC {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

#pragma mark ------ 打开链接 ------
/**
 * 打开浏览器
 */
+ (BOOL)openURL:(NSURL *)url {
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    } else {
        return NO;
    }
}
/**
 * 打电话
 */
+ (BOOL)openTel:(NSString *)tel {
    NSString *telString = [NSString stringWithFormat:@"tel://%@",tel];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:telString]]) {
        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    } else {
        return NO;
    }
}

#pragma mark -

/**
 * view旋转动画
 */
+ (void)rotateView:(UIView *)view angle:(CGFloat)angle {
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(view.transform, angle);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:0.3];
    //添加代理
    //[UIView setAnimationDelegate:self];
    //获取transform的值
    [view setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
}

/**
 * 图片变灰
 */
+ (UIImage *)grayImage:(UIImage *)sourceImage {
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

/**
 * 设置四个角任意角的圆角
 */
+ (void)cornerRadiusForView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners        //四个角选则
                                                         cornerRadii:cornerRadii];  //圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark -
// 关闭键盘
+ (void)closeKeyboard {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

/******* UITableView Utils *******/
+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message {
    UILabel *lb_headTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 20)];
    lb_headTitle.font = [UIFont boldSystemFontOfSize:15.0];
    lb_headTitle.textColor = [UIColor darkGrayColor];
    lb_headTitle.textAlignment = NSTextAlignmentCenter;
    lb_headTitle.text = message;
    return lb_headTitle;
}

+ (UIView *)tableViewsFooterView {
    UIView *coverView = [UIView new];
    coverView.backgroundColor = [UIColor clearColor];
    return coverView;
}

// 无标题返回按钮
+ (UIBarButtonItem *)navigationBackButtonWithNoTitle {
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - UIImage

/**
 * 获取纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    //Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

@end

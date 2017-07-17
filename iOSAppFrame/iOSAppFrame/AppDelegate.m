//
//  AppDelegate.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "AppDelegate.h"
#import "UIConstants.h"
#import "RootTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 导航栏颜色
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = NAV_BG_COLOR;
    //navigationBar.backgroundColor = NAV_BG_COLOR; //设置barTintColor而不是backgroundColor
    navigationBar.tintColor = NAV_TINT_COLOR;
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: NAV_TITLE_COLOR}];
    navigationBar.barStyle = UIBarStyleDefault;
    navigationBar.translucent = YES;
    // 状态栏(改为在BaseVC的preferredStatusBarStyle,支持单个页面自定义)
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 统一修改返回按钮
    UIImage *backImage = ImageWithName(@"navbar_back");
    backImage = [UIImage imageWithCGImage:backImage.CGImage scale:2.6 orientation:backImage.imageOrientation];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 0)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    [NSThread sleepForTimeInterval:2.0];//设置启动页面时间
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    RootTabBarController *tab = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    self.window.rootViewController = tab;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

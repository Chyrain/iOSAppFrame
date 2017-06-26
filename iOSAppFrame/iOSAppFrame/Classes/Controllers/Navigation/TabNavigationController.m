//
//  TabNavigationController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "TabNavigationController.h"
#import "UIConstants.h"

@interface TabNavigationController ()

@end

@implementation TabNavigationController

+ (void)load {
//    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil ];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    //    dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    dic[NSForegroundColorAttributeName] = UIColorFromRGB(0x252729);
//    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
//    
//    // appearanceWhenContainedInInstancesOfClasses的含义就是让UINavigationBar在EVNNavigationController表现为某种特性
//    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
//    NSMutableDictionary *dicBar = [NSMutableDictionary dictionary];
//    
//    dicBar[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    [navBar setTitleTextAttributes:dic];
    
    //    [[UITextField appearance] setTintColor:[UIColor blackColor]];       // 这样设置会改变所有的textfield的光标
    
    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];   // 设置返回按钮颜色
    //
    //    [navBar setBarTintColor:NaviColor];                                 // 设置导航条背景颜色
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //状态栏文字色调
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    return [super pushViewController:viewController animated:animated];
}

@end

//
//  BaseTableViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/6.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController () {
    BOOL hasFirstLayout;
}
@end

@implementation BaseTableViewController

/**
 * 适用于统计模块，界面生命周期中进行统计
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.navigationController.navigationBar.tintColor = NavTintColor; // 字体颜色
    self.navigationController.navigationBar.barTintColor = NavBarTintColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:[[self class] description]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:[[self class] description]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!hasFirstLayout) {
        hasFirstLayout = YES;
        [self onFirstLayoutSubviews];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)onFirstLayoutSubviews {
    //TODO 子类重写此方法
}

- (void)dismissSelf {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

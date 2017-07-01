//
//  MineCenterViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "MineCenterViewController.h"
#import "V5LoadingSuccessHUD.h"
#import "V5LoadingHUD.h"
#import "CustomBezierView.h"
#import "Masonry.h"

@interface MineCenterViewController ()

@end

@implementation MineCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalStr(@"MineCenter", @"我");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始加载" style:UIBarButtonItemStylePlain target:self action:@selector(showLoadingAnimation)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加载完成" style:UIBarButtonItemStylePlain target:self action:@selector(showSuccessAnimation)];
    
    CustomBezierView *bezierView = [[CustomBezierView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bezierView];
//    [self setupConstraintsOfView:bezierView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupConstraintsOfView:(UIView *)v {
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(40);
        make.centerX.mas_equalTo(self.view);
    }];
}

-(void)showLoadingAnimation{
    
    self.title = @"正在加载...";
    
    //隐藏支付完成动画
    [V5LoadingSuccessHUD hideIn:self.view];
    //显示支付中动画
    [V5LoadingHUD showIn:self.view];
}

-(void)showSuccessAnimation{
    
    self.title = @"加载完成";
    
    //隐藏支付中成动画
    [V5LoadingHUD hideIn:self.view];
    //显示支付完成动画
    [V5LoadingSuccessHUD showIn:self.view];
}

@end

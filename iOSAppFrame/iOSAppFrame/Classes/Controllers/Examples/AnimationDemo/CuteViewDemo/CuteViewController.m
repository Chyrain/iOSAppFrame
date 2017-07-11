//
//  CuteViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/6.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "CuteViewController.h"
#import "RYCuteView.h"

@interface CuteViewController ()

@end

@implementation CuteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Cute View";
    
    RYCuteView *cuteView = [[RYCuteView alloc] initWithFrame:self.view.frame];
    cuteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cuteView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

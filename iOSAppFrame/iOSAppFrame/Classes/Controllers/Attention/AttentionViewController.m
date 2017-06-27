//
//  AttentionViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "AttentionViewController.h"
#import "XLWaveProgress.h"

@interface AttentionViewController () {
    XLWaveProgress *_waveProgress;
}

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalStr(@"Attention", @"关注");
    
    _waveProgress = [[XLWaveProgress alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _waveProgress.center = self.view.center;
    _waveProgress.fontSize = 20;
    [self.view addSubview:_waveProgress];
    _waveProgress.progress = 0.0f;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_waveProgress.frame) + 20, self.view.bounds.size.width - 2*50, 20)];
    [slider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setMinimumTrackTintColor:[UIColor colorWithRed:96/255.0f green:159/255.0f blue:150/255.0f alpha:1]];
    [self.view addSubview:slider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sliderMethod:(UISlider*)slider {
    _waveProgress.progress = slider.value;
}

@end

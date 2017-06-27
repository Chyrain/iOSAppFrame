//
//  FindViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "FindViewController.h"
#import "XLBubbleTransition.h"
#import "Masonry.h"

@interface FindViewController ()
@property (strong, nonatomic) UIButton *button;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalStr(@"Find", @"发现");
    
    self.view.backgroundColor = [UIColor colorWithRed:253/255.0 green:216/255.0 blue:97/255.0 alpha:1];
    
    //示例label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = @"Hello!";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"AmericanTypewriter" size:40];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [self setupConstraintsOfLabel:label];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.button.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) - 40);
    [self.button setImage:[UIImage imageNamed:@"Add_icn"] forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor whiteColor]];
    self.button.layer.cornerRadius = self.button.bounds.size.width/2.0f;
    [self.button addTarget:self action:@selector(popMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    //在ViewControllerB中添加Present和Dismiss的动画
    self.xl_presentTranstion = [XLBubbleTransition transitionWithAnchorRect:self.button.frame];
    self.xl_dismissTranstion = [XLBubbleTransition transitionWithAnchorRect:self.button.frame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.button setTransform:CGAffineTransformMakeRotation(M_PI_4)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popMethod:(UIButton *)sender{
    [UIView animateWithDuration:0.35f animations:^{
        [sender setTransform:CGAffineTransformMakeRotation(-M_PI_4/2)];
    }];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - Private Methods
- (void)setupConstraintsOfLabel:(UILabel *)label {
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.view);
        make.center.mas_equalTo(self.view);
    }];
}


@end

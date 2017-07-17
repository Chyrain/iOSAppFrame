//
//  TransitionSecondViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "TransitionSecondViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface TransitionSecondViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImageUpCons;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@end

@implementation TransitionSecondViewController

#pragma mark - init & life

-(instancetype)init{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.fadeBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            [strongSelf.view layoutIfNeeded];
            
            strongSelf.detailImageUpCons.constant = 0;
            [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                strongSelf.detailImageView.alpha = 1;
                [strongSelf.view layoutIfNeeded];
            } completion: ^(BOOL finished){
            }];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    if (_coverImage) {
        self.coverImageView.image = _coverImage;
    }
    
    self.navigationController.navigationBar.translucent = YES;
    if (self.closeBlock) {
        self.detailImageView.alpha = 0;
        self.detailImageUpCons.constant = 25;
        [self.view layoutIfNeeded];
        //[self.navigationController.navigationBar setValue:@(0.0) forKeyPath:@"backgroundView.alpha"];
    } else {
        [self.navigationController.navigationBar setValue:@(0.0) forKeyPath:@"backgroundView.alpha"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        [self.navigationController.navigationBar setValue:@(1.0) forKeyPath:@"backgroundView.alpha"];
    } completion: ^(BOOL finished){
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBar.hidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
    if (self.closeBlock) {
        self.closeBlock(self);
    } else {
        [self dismissSelf];
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        self.view.alpha = 0;
    } completion: ^(BOOL finished){
    }];
}

- (BOOL)navigationShouldPopOnBackButton {
    NSLog(@"navigationShouldPopOnBackButton");
    [self backButtonClick:nil];
    return NO;
}

@end

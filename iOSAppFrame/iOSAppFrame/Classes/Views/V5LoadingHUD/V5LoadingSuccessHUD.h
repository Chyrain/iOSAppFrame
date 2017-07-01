//
//  V5LoadingSuccessHUD.h
//  V5LoadingHUDExample
//
//  Created by MengXianLiang on 2017/4/6.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V5LoadingSuccessHUD : UIView<CAAnimationDelegate>

- (void)start;

- (void)hide;

+ (V5LoadingSuccessHUD*)showIn:(UIView*)view;

+ (V5LoadingSuccessHUD*)hideIn:(UIView*)view;

@end

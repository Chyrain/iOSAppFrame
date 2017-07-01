//
//  V5LoadingHUD.h
//  V5LoadingHUDExample
//
//  Created by MengXianLiang on 2017/4/6.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V5LoadingHUD : UIView

- (void)start;

- (void)hide;

+ (V5LoadingHUD*)showIn:(UIView*)view;

+ (V5LoadingHUD*)hideIn:(UIView*)view;

@end

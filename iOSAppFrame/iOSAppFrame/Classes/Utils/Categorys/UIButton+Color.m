//
//  UIButton+Color.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "UIButton+Color.h"
#import "UITools.h"

@implementation UIButton (Color)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UITools imageWithColor:backgroundColor] forState:state];
}

@end

//
//  UIViewController+NIB.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/30.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "UIViewController+NIB.h"

@implementation UIViewController (NIB)

+ (instancetype)loadFromNib {
    // [self class]会由调用的类决定
    Class controllerClass = [self class];
    //NSLog(@"class = %@", controllerClass);
    return [[controllerClass alloc] initWithNibName:NSStringFromClass(controllerClass) bundle:[NSBundle mainBundle]];
}

@end

//
//  UIViewController+NIB.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/30.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NIB)
// 要求xib文件名和View Controller类名一致
+ (instancetype)loadFromNib;
@end

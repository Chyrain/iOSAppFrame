//
//  TransitionSecondViewController.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^HYNoParaBlock)(void);
typedef void(^HYContainIDBlock)(id);

@interface TransitionSecondViewController : BaseViewController
/** coverImage */
@property(nonatomic, strong) UIImage *coverImage;

/** 进入出现动画 */
@property(nonatomic, strong) HYNoParaBlock fadeBlock;

/** 关闭动画 */
@property(nonatomic, strong) HYContainIDBlock closeBlock;
@end

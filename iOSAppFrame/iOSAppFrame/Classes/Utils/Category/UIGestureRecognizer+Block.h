//  使用 Block 创建 UIGestureRecognizer
//  UIGestureRecognizer+Block.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/29.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NVMGestureBlock)(id UIGestureRecognizer);

@interface UIGestureRecognizer (Block)
+ (instancetype)nvm_gestureRecognizerWithActionBlock:(NVMGestureBlock)block;
- (instancetype)initWithActionBlock:(NVMGestureBlock)Block;
@end

//  使用 Block 创建 UIGestureRecognizer
//  UIGestureRecognizer+Block.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/29.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "UIGestureRecognizer+Block.h"
#import <objc/runtime.h>

static const int target_key;

@implementation UIGestureRecognizer (Block)

+ (instancetype)nvm_gestureRecognizerWithActionBlock:(NVMGestureBlock)block {
    return [[self alloc] initWithActionBlock:block];
}

- (instancetype)initWithActionBlock:(NVMGestureBlock)block {
    self = [self initWithTarget:self action:@selector(invoke:)];
    [self addActionBlock:block];
    //[self addTarget:self action:@selector(invoke:)];
    return self;
}

- (void)addActionBlock:(NVMGestureBlock)block {
    if (block) {
        objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)invoke:(id)sender {
    NSLog(@"invoke:sender %@", sender);
    NVMGestureBlock block = objc_getAssociatedObject(self, &target_key);
    if (block) {
        block(sender);
    }
}

@end

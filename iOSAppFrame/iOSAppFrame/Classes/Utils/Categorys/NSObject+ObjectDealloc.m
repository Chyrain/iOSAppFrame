//  监控指定对象是否正常释放
//  NSObject+ObjectDealloc.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/30.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "NSObject+ObjectDealloc.h"
#import <objc/runtime.h>

void objDealloc_Swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation NSObject (ObjectDealloc)

- (void)setShouldLogWhenDealloc:(BOOL)shouldLogWhenDealloc {
    objc_setAssociatedObject(self, @selector(shouldLogWhenDealloc), @(shouldLogWhenDealloc),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldLogWhenDealloc {
    return [objc_getAssociatedObject(self, @selector(shouldLogWhenDealloc)) boolValue];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objDealloc_Swizzle(self, NSSelectorFromString(@"dealloc"), @selector(_myDealloc));
    });
}

+ (NSString *)nameOfClass {
    return NSStringFromClass([self class]);
}

- (void)_myDealloc {
    if (self.shouldLogWhenDealloc) {
        NSLog(@"--- 💀 --- %@ Dealloc!",NSStringFromClass([self class]));
    }
    [self _myDealloc];
}

@end

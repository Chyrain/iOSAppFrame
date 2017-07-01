//
//  NSObject+CRKVO.m
//  mcss
//
//  Created by chyrain on 2017/2/25.
//  Copyright © 2017年 V5KF. All rights reserved.
//

#import "NSObject+CRKVO.h"
#import "Macros.h"
#import <objc/runtime.h>

@implementation NSObject (V5CRKVO)

// Category添加属性宏
ADD_DYNAMIC_PROPERTY(NSMutableDictionary*,cr_observerDic,setCr_observerDic);
    
- (void)removeAllCRObserver {
//    NSLog(@"KVO [removeAllCRObserver] cr_observerDic: %zi", [self.cr_observerDic count]);
    if (self.cr_observerDic) { //key -> array
        for (NSString *key in self.cr_observerDic) {
            NSMutableArray *arr = [self.cr_observerDic objectForKey:key];
            if (arr) {
                [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     [self removeObserver:obj forKeyPath:key];
                 }];
                [arr removeAllObjects];
            }
        }
        [self.cr_observerDic removeAllObjects];
    }
}

- (void)addCRObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    NSMutableArray *arr;
    if (self.cr_observerDic && [self.cr_observerDic objectForKey:keyPath]) { //key -> array
        // 已注册，直接返回
        arr = [self.cr_observerDic objectForKey:keyPath];
        if ([arr containsObject:observer]) {
            NSLog(@"KVO => %@ 重复监听 addCRObserver:%@ forKeyPath:%@ options:%lu context:%@", self, observer, keyPath, (unsigned long)options, context);
            return;
        }
    }
//    NSLog(@"KVO => %@ addCRObserver:%@ forKeyPath:%@ options:%lu context:%@", self, observer, keyPath, (unsigned long)options, context);
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
    // 添加记录
    if (!self.cr_observerDic) {
        self.cr_observerDic = [NSMutableDictionary dictionary];
    }
    if (!arr) {
        arr = [NSMutableArray array];
        [arr addObject:observer];
        [self.cr_observerDic setObject:arr forKey:keyPath];
    } else {
        [arr addObject:observer];
    }
//    NSLog(@"KVO cr_observerDic: %zi", [self.cr_observerDic count]);
}

- (void)removeCRObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    //    NSLog(@"KVO => %@ removeCRObserver:%@ forKeyPath:%@", self, observer, keyPath);
    BOOL doe = [self removeCr_Observer:observer forKeyPath:keyPath];
    if (doe) {
        [self removeObserver:observer forKeyPath:keyPath];
    }
//    NSLog(@"KVO => %@ removeCRObserver:%@ forKeyPath:%@ [done: %d]", self, observer, keyPath, doe);
}

- (void)removeCRObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    //    NSLog(@"KVO => %@ removeCRObserver:%@ forKeyPath:%@ context:%@", self, observer, keyPath, context);
    BOOL doe = [self removeCr_Observer:observer forKeyPath:keyPath];\
    if (doe) {
        [self removeObserver:observer forKeyPath:keyPath context:context];
    }
//    NSLog(@"KVO => %@ removeCRObserver:%@ forKeyPath:%@ [done: %d]", self, observer, keyPath, doe);
}
    
- (BOOL)removeCr_Observer:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (self.cr_observerDic && [self.cr_observerDic objectForKey:keyPath]) { //key -> array
        // 已注册，直接返回
        NSMutableArray *arr = [self.cr_observerDic objectForKey:keyPath];
        if (arr && [arr containsObject:observer]) {
            [arr removeObject:observer];
            if (arr.count == 0) {
                [self.cr_observerDic removeObjectForKey:keyPath];
            }
            return YES;
        }
        if (!arr || arr.count == 0) {
            [self.cr_observerDic removeObjectForKey:keyPath];
        }
    }
    return NO;
}

@end

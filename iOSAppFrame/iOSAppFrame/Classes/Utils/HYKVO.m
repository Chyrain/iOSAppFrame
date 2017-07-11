//
//  HYKVO.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/9.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYKVO.h"
//加入头文件
#import <objc/message.h>

@interface HYKVO ()
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, copy) HYObserverBlock block;
@property(nonatomic, unsafe_unretained)id observedObject;

@end

@implementation HYKVO

- (void)dealloc
{
    if(_observedObject) {
        [self stopObserving];
    }
}

- (void)stopObserving
{
    [_observedObject removeObserver:self forKeyPath:_keyPath];
    _observedObject = nil;
    self.block = nil;
    self.keyPath = nil;
}


#pragma mark -- Block

+ (id)observerForObject:(id)object
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
            changeBlock:(HYObserverBlock)block
{
    HYKVO *observer = [[HYKVO alloc] init];
    if(observer)
    {
        if(!object || !keyPath || !block)
        {
            // 抛出异常
            [NSException raise:NSInternalInconsistencyException format:@"Observation must have a valid object (%@), keyPath (%@) and block(%@)", object, keyPath, block];
            observer = nil;
        } else
        {
            observer.observedObject = object;
            observer.keyPath = keyPath ;
            observer.block = block;
            
            [observer.observedObject addObserver:observer
                                      forKeyPath:observer.keyPath
                                         options:options
                                         context:NULL];
        }
    }
    return observer;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    (self.block)(change);
}

#pragma mark -- Selector

+ (id)observerForObject:(id)object
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                 target:(id)target
                 action:(SEL)action
{
    id observer = nil;
    
    __weak id wTarget = target;
    __weak id wObject = object;
    
    HYObserverBlock block =  ^(NSDictionary *change) {
        id msgTarget = wTarget;
        if(msgTarget) {
            ((void(*)(id, SEL, id, NSString *, NSDictionary *))objc_msgSend)(msgTarget, action, wObject, keyPath, change);
        }
    };
    
    if(block) {
        observer = [HYKVO observerForObject:object keyPath:keyPath options:options changeBlock:block];
    }
    
    return observer;
}
@end

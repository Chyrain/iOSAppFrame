//
//  NSObject+CRKVO.h
//  mcss
//
//  Created by chyrain on 2017/2/25.
//  Copyright © 2017年 V5KF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (V5CRKVO)

@property (nonatomic, copy) NSMutableDictionary *cr_observerDic;

- (void)addCRObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)removeCRObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)removeCRObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;
- (void)removeAllCRObserver;

@end

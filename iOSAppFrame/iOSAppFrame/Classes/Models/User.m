//
//  User.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/5.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "User.h"

@implementation User

// 手动KVO name 或 automaticallyNotifiesObserversForKey:
+ (BOOL)automaticallyNotifiesObserversOfName {
    return NO;
}

// 手动KVO 需要手动实现属性的 setter 方法，可加上 name 的判断条件
- (void)setName:(NSString *)name {
    if (!name || [name isEqualToString:@""]) {
        return;
    }
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}

// 依赖键： keyPathsForValuesAffectingInformation 或 keyPathsForValuesAffectingValueForKey:


// KVC
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 未找到默认抛出NSUndefinedKeyeException,可重写setValue:orUndefinedKey:来实现不同
}
//+ (BOOL)accessInstanceVariablesDirectly {
//    return YES;
//}

+ (NSSet *)keyPathsForValuesAffectingDesc {
    NSSet *set = [NSSet setWithObjects:@"name", @"age", nil];
    return set;
}

- (NSString *)desc {
    return [NSString stringWithFormat:@"%@(%zi)", self.name, self.age];
}

@end

//
//  NSObject+CoderExtension.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/8/14.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "NSObject+CoderExtension.h"
#import <objc/runtime.h>

@implementation NSObject (CoderExtension)

//// 设置需要忽略的属性(使用此Category的对象实现)
//- (NSArray *)ignoredNames {
//    return @[@"bone"];
//}

/*
 
 // 设置需要[忽略]的属性
 - (NSArray *)ignoredNames {
 return @[@"bone"];
 }
 
 // 在系统方法内来调用我们的方法
 - (instancetype)initWithCoder:(NSCoder *)aDecoder {
 if (self = [super init]) {
 [self decode:aDecoder];
 }
 return self;
 }
 
 - (void)encodeWithCoder:(NSCoder *)aCoder {
 [self encode:aCoder];
 }
 
 
 以下是对该类序列化和反序列化。
 NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:self.DataArray];
 [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:@"DataArray"];
 
 NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataArray"];
 self.dataList = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
 
 */

- (void)encode:(NSCoder *)aCoder {
    // 一层层父类往上查找，对父类的属性执行归解档方法
    Class c = self.class;
    while (c && c != [NSObject class]) {
        
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 如果有实现该方法再去调用
            if ([self respondsToSelector:@selector(ignoredNames)]) {
                if ([[self ignoredNames] containsObject:key]) continue;
            }
            
            id value = [self valueForKeyPath:key];
            [aCoder encodeObject:value forKey:key];
        }
        free(ivars);
        c = [c superclass];
    }
}

- (void)decode:(NSCoder *)aDecoder {
    // 一层层父类往上查找，对父类的属性执行归解档方法
    Class c = self.class;
    while (c && c != [NSObject class]) {
        
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 如果有实现该方法再去调用
            if ([self respondsToSelector:@selector(ignoredNames)]) {
                if ([[self ignoredNames] containsObject:key]) continue;
            }
            
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
        c = [c superclass];
    }
}

@end

//
//  NSObject+Dictionary.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "NSObject+Dictionary.h"
#import <objc/runtime.h>
#define DisableToDictionary 0

@implementation NSObject (Dictionary)

- (NSDictionary *)toDictionary {
    
    return [self convertModelToDictionary:self nullEnable:NO];
}

- (NSDictionary *)toDictionary:(BOOL)nullEnable {
    
    return [self convertModelToDictionary:self nullEnable:nullEnable];
}

- (NSDictionary *)convertModelToDictionary:(id)model nullEnable:(BOOL)nullEnable {
    if (DisableToDictionary) {
        return nil;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (!model) {
        return dic;
    }
    for (NSString *key in [self propertyNames:[model class]]) {
        //V5LogVerbose(@"toDictionary -> key:%@ ->value:%@", key, [model valueForKey:key]);
        id propertyValue = [model valueForKey:key];
        if (nullEnable && !propertyValue) {
            propertyValue = [NSNull null];
        }
        //该值不为NSNULL，并且也不为nil
        if (propertyValue) {
            if ([propertyValue respondsToSelector:@selector(toDictionary:)] &&
                [self isCustomClass:[propertyValue class]]) {
                propertyValue = [propertyValue toDictionary:nullEnable];
            }
            [dic setObject:propertyValue forKey:key];
        }
    }
    
    return dic;
}

//获取一个类的属性名字列表
- (NSArray *)propertyNames:(Class)class {
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    for (unsigned int i =0; i<propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

//判断一个类是否是自定义的类
- (BOOL)isCustomClass:(Class)class {
    NSBundle *classBundle = [NSBundle bundleForClass:class];
    if (classBundle == [NSBundle mainBundle]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)fullDescription {
    return [NSString stringWithFormat:@"<%@: %p, %@>",
            [[self class] description],
            self,
            [self toDictionary:YES]];
}

@end

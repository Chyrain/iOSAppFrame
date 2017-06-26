//
//  UserDefaultsUtils.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsUtils : NSObject

+ (void)saveValue:(id)value forKey:(NSString *)key;

+ (id)valueWithKey:(NSString *)key;

+ (BOOL)boolValueWithKey:(NSString *)key;

+ (void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+ (void)print;

@end

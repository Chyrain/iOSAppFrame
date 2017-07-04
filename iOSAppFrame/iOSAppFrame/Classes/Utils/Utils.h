//
//  Utils.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utils : NSObject

// MD5
+ (NSString *)md5:(NSString *)input;
+ (NSString *)md5OfData:(NSData *)data;

// URL编解码
+ (NSString*)encodeString:(NSString*)unencodedString;
+ (NSString *)decodeString:(NSString*)encodedString;

// 将汉字转换为拼音
+ (NSString*)chineseToPinyin:(NSString*)chinese withSpace:(BOOL)withSpace;

// 字符串判空
+ (BOOL)isEmptyString:(NSString *)str;
// 字符串判空，排除空格字符
+ (BOOL)isBlankString:(NSString *)string;

#pragma mark -
// 文件是否存在
+ (BOOL)isFileExists:(NSString *)path;
// 文件夹大小
+ (CGFloat)folderSizeAtPath:(NSString*)folderPath;
// 文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath;
// 删除指定路径文件
+ (void)deleteFileWithPath:(NSString *)path;

#pragma mark -
// 验证email
+ (BOOL)isEmail:(NSString *)input;
// 验证手机号
+ (BOOL)isMobileNum:(NSString *)input;
// 验证身份证号
+ (BOOL)isIdentityCardNo:(NSString *)input;
// 验证邮编
+ (BOOL)isZipCode:(NSString *)input;
// 验证数字
+ (BOOL)isNumber:(NSString *)input;

#pragma mark -
// 读取保存自己定义的plist文件
+ (void)saveConfigWithValue:(NSString *)value forKey:(NSString *)key;
+ (id)readConfigValueWithKey:(NSString *)key;

// 读取保存系统默认偏好plist文件
+ (void)savePreferencesWithValue:(NSString *)value forKey:(NSString *)key;
+ (id)readPreferencesValueWithKey:(NSString *)key;

// 读取保存临时保存信息plist文件
+ (void)saveTempWithValue:(NSString *)value forKey:(NSString *)key;
+ (id)readTempValueWithKey:(NSString *)key;

@end

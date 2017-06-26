//
//  Utils.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

#define CONFIG_FILE @"Config.plist"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation Utils

#pragma mark -
+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)md5OfData:(NSData *)data {
    const char* original_str = (const char *)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (CC_LONG)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x",digist[i]]; //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

#pragma mark - URL编解码
//URLEncode
+ (NSString*)encodeString:(NSString*)unencodedString {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)@"[].", NULL, (CFStringRef)@"!*'();:@&=+$,/?%#", kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDecode
+ (NSString *)decodeString:(NSString*)encodedString {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)encodedString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

#pragma mark -

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyString:(NSString *)str {
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

//将汉字转换为拼音
+ (NSString*)chineseToPinyin:(NSString*)chinese withSpace:(BOOL)withSpace {
    if(chinese) {
        CFStringRef hanzi = (__bridge CFStringRef)chinese;
        CFMutableStringRef string = CFStringCreateMutableCopy(NULL,0, hanzi);
        CFStringTransform(string,NULL, kCFStringTransformMandarinLatin,NO);
        CFStringTransform(string,NULL, kCFStringTransformStripDiacritics,NO);
        NSString*pinyin = (NSString*)CFBridgingRelease(string);
        if(!withSpace) {
            pinyin = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        return pinyin;
    }
    return nil;
}

#pragma mark -

+ (BOOL)isFileExists:(NSString *)path {
    if (!path) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

// 文件夹的大小
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0f * 1024.0f);
}

// 单个文件的大小
+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 删除指定路径文件
+ (void)deleteFileWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil]) {
        NSLog(@"delete file success:%@", path);
    }
}



#pragma mark - 验证输入信息

// 验证email
+ (BOOL)isEmail:(NSString *)input {
    
    NSString   *emailRegex = @"^([a-zA-Z0-9]*[-_]?[a-zA-Z0-9]+)*@([a-zA-Z0-9]*[-_]?[a-zA-Z0-9]+)+[\\.][A-Za-z]{2,3}([\\.][A-Za-z]{2})?$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}

// 验证手机号
+ (BOOL)isMobileNum:(NSString *)input {
    
    NSString * MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0,3,5-9]))\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:input];
    BOOL res2 = [regextestcm evaluateWithObject:input];
    BOOL res3 = [regextestcu evaluateWithObject:input];
    BOOL res4 = [regextestct evaluateWithObject:input];
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    } else {
        return NO;
    }
}

// 验证身份证号
+ (BOOL)isIdentityCardNo:(NSString *)input {
    
    NSString   *emailRegex = @"\\d{15}|(\\d{17}([0-9]|X|x)$)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}

// 验证邮编
+ (BOOL)isZipCode:(NSString *)input {
    
    NSString   *emailRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}

// 验证数字
+ (BOOL)isNumber:(NSString *)input {
    
    NSString   *numRegex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    return [numTest evaluateWithObject:input];
}

#pragma mark -

// 写入和读取指定plist
+ (void)saveConfigWithValue:(NSString *)value forKey:(NSString *)key {
    // 获取应用沙盒的Douch
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *plist = [paths objectAtIndex:0];
    // 获取一个plist文件
    NSString *path = [plist stringByAppendingPathComponent:CONFIG_FILE];
    
    // 读取数据
    NSMutableArray* data = [NSMutableArray arrayWithContentsOfFile:path];
    NSMutableDictionary *dic = [data objectAtIndex:0];
    if (!data) {
        data = [[NSMutableArray alloc] initWithCapacity:1];
    }
    if (!dic) {
        dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        [data addObject:dic];
    }
    
    // 设置值
    [dic setObject:value forKey:key];
    [data writeToFile:path atomically:YES];
}
+ (id)readConfigValueWithKey:(NSString *)key {
    // 获取应用沙盒的Douch
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *plist1 = [paths objectAtIndex:0];
    
    // 获取一个plist文件
    NSString *path = [plist1 stringByAppendingPathComponent:CONFIG_FILE];
    //    NSDictionary* data = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray* data = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    return [[data objectAtIndex:0] objectForKey:key];
}

// 写入和读取NSUserDefaults
+ (void)savePreferencesWithValue:(NSString *)value forKey:(NSString *)key {
    // 获取标准函数对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}
+ (id)readPreferencesValueWithKey:(NSString *)key {
    // 获取标准函数对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

// 写入和读取Temp临时目录
+ (void)saveTempWithValue:(NSString *)value forKey:(NSString *)key {
    // 获取tmp路径
    NSString *path = NSTemporaryDirectory();
    
    // 读取数据
    NSMutableArray* data = [NSMutableArray arrayWithContentsOfFile:path];
    NSMutableDictionary *dic = [data objectAtIndex:0];
    if (!data) {
        data = [[NSMutableArray alloc] initWithCapacity:1];
    }
    if (!dic) {
        dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        [data addObject:dic];
    }
    
    // 设置值
    [dic setObject:value forKey:key];
    [data writeToFile:path atomically:YES];}
+ (id)readTempValueWithKey:(NSString *)key {
    // 获取tmp路径
    NSString *path = NSTemporaryDirectory();
    NSMutableArray* data = [[NSMutableArray alloc] initWithContentsOfFile:path];
    return [[data objectAtIndex:0] objectForKey:key];
}

/********************** NSDate Utils ***********************/
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter; {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

//字符串#ffffff转UIColor
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end

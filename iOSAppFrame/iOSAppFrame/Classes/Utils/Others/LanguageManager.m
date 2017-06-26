//
//  LanguageManager.m
//  ios_language_manager
//
//  Created by Maxim Bilan on 12/23/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "LanguageManager.h"
#import "NSBundle+Language.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Macros.h"
#import "Utils.h"

static NSString * const LanguageCodes[] = {@"zh-Hans", @"en"}; //{ @"en", @"de", @"fr", @"ar" };
static NSString * const LanguageStrings[] = {@"中文", @"English"}; //{ @"English", @"German", @"French", @"Arabic" };
static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LanguageManager

+ (void)setupCurrentLanguage
{
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    if (!currentLanguage) {
        id alanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSLog(@"AppleLanguages:%@ : %@", [[alanguages class] description], alanguages);
        NSArray *languages = alanguages;
        if (languages.count > 0) {
            currentLanguage = languages[0];
            [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:LanguageSaveKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    NSLog(@"currentLanguage:%@", currentLanguage);
#ifndef USE_ON_FLY_LOCALIZATION
    [[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#else
    [NSBundle setLanguage:currentLanguage];
#endif
}

+ (NSArray *)languageStrings
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        [array addObject:NSLocalizedString(LanguageStrings[i], @"")];
    }
    return [array copy];
}

+ (NSString *)currentLanguageString
{
    NSString *string = @"";
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode containsString:LanguageCodes[i]]) {
            string = NSLocalizedString(LanguageStrings[i], @"");
            break;
        }
    }
    return string;
}

+ (NSString *)currentLanguageCode
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [def objectForKey:@"AppleLanguages"];
    NSString *current = [languages objectAtIndex:0];
    NSString *saveLang = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    if ([Utils isEmptyString:saveLang]) {
        [NSBundle setLanguage:current];
        return current;
    }
    return saveLang;

    //return [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
}

+ (NSInteger)currentLanguageIndex
{
    NSInteger index = 0;
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode containsString:LanguageCodes[i]]) {
            index = i;
            break;
        }
    }
    return index;
}

/* 保存当前选择的语言 */
+ (void)saveLanguageByIndex:(NSInteger)index
{
    if (index >= 0 && index < ELanguageCount) {
        NSString *code = LanguageCodes[index];
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:LanguageSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef USE_ON_FLY_LOCALIZATION
        [NSBundle setLanguage:code];
#endif
    }
}

+ (BOOL)isCurrentLanguageRTL
{
	NSInteger currentLanguageIndex = [self currentLanguageIndex];
	return ([NSLocale characterDirectionForLanguage:LanguageCodes[currentLanguageIndex]] == NSLocaleLanguageDirectionRightToLeft);
}

/* 改变语言后重新加载应用 */
+ (void)reloadRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

@end

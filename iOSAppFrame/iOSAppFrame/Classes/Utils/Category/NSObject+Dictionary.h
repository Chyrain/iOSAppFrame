//
//  NSObject+Dictionary.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Dictionary)
// 默认不显示Null的值
- (NSDictionary *)toDictionary;
// 是否显示Null值
- (NSDictionary *)toDictionary:(BOOL)nullEnable;
- (NSString *)fullDescription;

@end

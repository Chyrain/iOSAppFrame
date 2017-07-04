//
//  User+Extensions.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/5.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "User+Extensions.h"

@implementation User (Extensions)

/**
 * 把Module的业务逻辑放到扩展中来，保持Model的简洁与单一性
 */
- (NSArray*)currentPriorities {
    NSDate* now = [NSDate date];
    NSString* formatString = @"startDate = %@";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:formatString, now, now];
    return [[self.priorities filteredSetUsingPredicate:predicate] allObjects];
}
@end

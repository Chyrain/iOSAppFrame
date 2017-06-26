//
//  BaseModule.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "BaseModule.h"

@implementation BaseModule

- (NSString *)fullDescription {
    return [NSString stringWithFormat:@"<%@: %p, %@>",
            [[self class] description],
            self,
            [self toDictionary:YES]];
}

@end

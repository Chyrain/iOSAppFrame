//
//  NSObject+CoderExtension.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/8/14.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CoderExtension)

- (NSArray *)ignoredNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;

@end

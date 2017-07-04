//
//  User.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/5.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "BaseModule.h"

@interface User : BaseModule

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSSet *priorities;

@end

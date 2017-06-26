//
//  UIAlertView+Blocks.h
//  AlertController
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertViewBlock)(UIAlertView *alertView);
typedef void (^AlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (Blocks)

@property (nonatomic, copy) AlertViewBlock didPresentBlock;
@property (nonatomic, copy) AlertViewCompletionBlock clickedButtonBlock;

@end

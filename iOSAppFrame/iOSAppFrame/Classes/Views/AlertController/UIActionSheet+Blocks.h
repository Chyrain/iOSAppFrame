//
//  UIActionSheet+Blocks.h
//  AlertController
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionSheetBlock)(UIActionSheet *actionSheet);
typedef void (^ActionSheetCompletionBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (Blocks)

@property (nonatomic, copy) ActionSheetBlock didPresentBlock;
@property (nonatomic, copy) ActionSheetCompletionBlock clickedButtonBlock;

@end

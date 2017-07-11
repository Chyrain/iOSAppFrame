//
//  BaseTableViewController.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/6.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

/**
 * 首次LayoutView时加载，用于修正子view的frame
 */
- (void)onFirstLayoutSubviews;
/**
 * 关闭
 */
- (void)dismissSelf;

@end

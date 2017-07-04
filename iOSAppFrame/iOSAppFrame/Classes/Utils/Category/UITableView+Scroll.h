//
//  UITableView+Scroll.h
//  DoctorClient
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Scroll)
-(void)scrollToBottom;
-(void)scrollToBottom:(BOOL)animation;
-(void)scrollToIndex:(NSIndexPath *)index animation:(BOOL)animation;
-(void)scrollToRow:(NSInteger)row animation:(BOOL)animation;

//去掉tableView多余行
-(void)clearEmptyCells;
@end

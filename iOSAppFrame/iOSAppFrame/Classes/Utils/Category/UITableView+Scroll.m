//
//  UITableView+Scroll.m
//  DoctorClient
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "UITableView+Scroll.h"

@implementation UITableView (Scroll)
-(void)scrollToBottom{
    [self scrollToBottom:YES];
}
-(void)scrollToBottom:(BOOL)animation
{
    NSInteger section=1;
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        section=[self.dataSource numberOfSectionsInTableView:self];
    }
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSInteger row=[self.dataSource tableView:self numberOfRowsInSection:section-1];
        if (row>0||section>1) {
            NSIndexPath * index=[NSIndexPath indexPathForRow:row-1 inSection:section-1];
            [self scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animation];
        }
    }
}

-(void)scrollToIndex:(NSIndexPath *)index animation:(BOOL)animation
{
    [self scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:animation];
}
-(void)scrollToRow:(NSInteger)row animation:(BOOL)animation
{
    NSIndexPath * index=[NSIndexPath indexPathForRow:row inSection:0];
    [self scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:animation];
}

- (void)clearEmptyCells {
    //去掉tableView多余行
    [self setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

@end

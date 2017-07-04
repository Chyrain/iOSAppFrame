//
//  HostSearchWordsTableViewCell.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/4.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HostSearchWordsTableViewCell.h"

@implementation HostSearchWordsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            UIView *confirmView = (UIView *)[subView.subviews firstObject];
            //改背景颜色
            //            confirmView.backgroundColor=[UIColor purpleColor];
            for(UIView *sub in confirmView.subviews) {
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
                    UILabel *deleteLabel = (UILabel *)sub; // 改删除按钮的字体大小
                    
                    deleteLabel.font = [UIFont systemFontOfSize:12];
                    deleteLabel.text=@"删除"; // 改删除按钮的文字
                }
            }
            break;
        }
    }
}

@end

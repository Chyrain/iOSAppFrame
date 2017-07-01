//
//  HYXibView.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/30.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYXibView.h"

@implementation HYXibView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self loadView];
}

- (NSString *)getXibName {
    NSString *clzzName = NSStringFromClass(self.classForCoder);
    NSArray *nameArray = [clzzName componentsSeparatedByString:@"."];
    NSString *xibName = nameArray[0];
    if (nameArray.count == 2) {
        xibName = nameArray[1];
    }
    return xibName;
}

- (void)loadView {
    if (self.contentView) {
        return;
    }
    self.contentView = [self loadViewWithNibName:[self getXibName] owner:self];
    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
}

- (UIView *)loadViewWithNibName:(NSString *)fileName owner:(id)owner {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:fileName owner:owner options:nil];
    return (UIView *)nibs[0];
}

@end

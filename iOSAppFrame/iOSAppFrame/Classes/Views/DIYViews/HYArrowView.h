//
//  HYArrowView.h
//  mcss
//
//  Created by chyrain on 2017/9/18.
//  Copyright © 2017年 V5KF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYArrowView : UIView

@property (nonatomic, assign) CGFloat duration;

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor arrowDown:(BOOL)down;
- (void)arrowUpWithAnimation:(BOOL)animation;
- (void)arrowDownWithAnimation:(BOOL)animation;
@end

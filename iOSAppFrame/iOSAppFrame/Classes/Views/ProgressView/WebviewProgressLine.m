//
//  WebviewProgressLine.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/9/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "WebviewProgressLine.h"
#import "Macros.h"

#define KScreenWidth Main_Screen_Width

@implementation WebviewProgressLine

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

-(void)startLoadingAnimation{
    self.hidden = NO;
    //self.width = 0.0;
    RECT_CHANGE_width(self, 0.0);
    
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        //weakSelf.width = KScreenWidth * 0.6;
        RECT_CHANGE_width(weakSelf, KScreenWidth * 0.6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            //weakSelf.width = KScreenWidth * 0.8;
            RECT_CHANGE_width(weakSelf, KScreenWidth * 0.8);
        }];
    }];
    
    
}

-(void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        //weakSelf.width = KScreenWidth;
        RECT_CHANGE_width(weakSelf, KScreenWidth);
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

@end

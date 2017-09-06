//
//  PlayingLineView.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/8/10.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingLineView : UIView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor;

//暂停
-(void)pause;

//开始
-(void)start;
@end

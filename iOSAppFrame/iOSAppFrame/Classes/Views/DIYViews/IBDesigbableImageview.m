//
//  IBDesigbableImageview.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/3.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "IBDesigbableImageview.h"

@implementation IBDesigbableImageview

-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0 ?true:false;
}

@end

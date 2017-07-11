//
//  HYPhotoView.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPhotoView : UIScrollView
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
- (void)setImage:(UIImage *)image;
@end

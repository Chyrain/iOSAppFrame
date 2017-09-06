//
//  HYImageLoader.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^HYImageLoadCompletionBlock)(UIImage *image, NSError *error, NSString *imageURL);

@interface HYImageLoader : NSObject

// 使用默认的placeholderImage、failureImage和completedBlock
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url;

// 使用默认的completedBlock和failureImage
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

// 使用默认的completedBlock
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url placeholderImage:(UIImage *)placeholder failureImage:(UIImage *)failureImage;

// 使用默认的placeholderImage和failureImage
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url completed:(HYImageLoadCompletionBlock)completedBlock;

// 全部参数自定义
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url placeholderImage:(UIImage *)placeholder failureImage:(UIImage *)failureImage completed:(HYImageLoadCompletionBlock)completedBlock;

// 设置按钮背景图片，全部参数自定义
+ (void)setButton:(UIButton *)button withBackgroundImageURL:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder failureImage:(UIImage *)failureImage complete:(HYImageLoadCompletionBlock)completeBlock;

@end

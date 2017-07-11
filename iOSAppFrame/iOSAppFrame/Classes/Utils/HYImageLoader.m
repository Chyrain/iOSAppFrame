//
//  HYImageLoader.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYImageLoader.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "Utils.h"

@implementation HYImageLoader

// 使用默认的placeholderImage、failureImage和completedBlock
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url {
    [self setImageView:imageView
               withURL:url
      placeholderImage:[UIImage imageNamed:IMGFILE(@"hy_image_loading")]
          failureImage:[UIImage imageNamed:IMGFILE(@"hy_image_failure")]
             completed:^(UIImage *image, NSError *error, NSString *imageURL) {
                 // TODO
                 
             }];
}

// 使用默认的completedBlock和failureImage
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url placeholderImage:(UIImage *)placeholder {
    [self setImageView:imageView
               withURL:url
      placeholderImage:placeholder
          failureImage:[UIImage imageNamed:IMGFILE(@"hy_image_failure")]
             completed:^(UIImage *image, NSError *error, NSString *imageURL) {
                 // TODO
                 
             }];
}

// 使用默认的completedBlock
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url placeholderImage:(UIImage *)placeholder failureImage:(UIImage *)failureImage {
    [self setImageView:imageView
               withURL:url
      placeholderImage:placeholder
          failureImage:failureImage
             completed:^(UIImage *image, NSError *error, NSString *imageURL) {
                 // TODO
                 
             }];
}

// 使用默认的placeholderImage和failureImage
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url completed:(HYImageLoadCompletionBlock)completedBlock {
    [self setImageView:imageView
               withURL:url
      placeholderImage:[UIImage imageNamed:IMGFILE(@"hy_image_loading")]
          failureImage:[UIImage imageNamed:IMGFILE(@"hy_image_failure")]
             completed:completedBlock];
}

// 全部参数自定义
+ (void)setImageView:(UIImageView *)imageView withURL:(NSString *)url placeholderImage:(UIImage *)placeholder failureImage:(UIImage *)failureImage completed:(HYImageLoadCompletionBlock)completedBlock {
    url = [Utils http2httpsOfurl:url];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:placeholder
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            // TODO 通知对话界面图片加载完成?
                            NSLog(@"sd_setImageWithURL<%@> -> completed", url);
                            if (image == nil || error != nil) { // 失败
                                NSLog(@"V5CRImageLoader -> load image failed url:%@", imageURL);
                                if (failureImage != nil) {
                                    [imageView setImage:failureImage];
                                }
                            }
                            if (completedBlock) {
                                completedBlock(image, error, url);
                            }
                        }];
}

// 设置按钮背景图片，全部参数自定义
+ (void)setButton:(UIButton *)button withBackgroundImageURL:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder failureImage:(UIImage *)failureImage complete:(HYImageLoadCompletionBlock)completeBlock {
    url = [Utils http2httpsOfurl:url];
    
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:url]
                                forState:state
                        placeholderImage:placeholder
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   // TODO 通知对话界面图片加载完成?
                                   NSLog(@"sd_setBackgroundImageWithURL<%@> -> completed", url);
                                   if (image == nil || error != nil) { // 失败
                                       NSLog(@"V5CRImageLoader -> load image failed url:%@", imageURL);
                                       if (failureImage != nil) {
                                           [button setBackgroundImage:failureImage forState:state];
                                       }
                                   }
                                   if (completeBlock) {
                                       completeBlock(image, error, url);
                                   }
                               }];
}

@end

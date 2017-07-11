//
//  HYImageBrowser.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYImageBrowser.h"
#import "HYPhotoView.h"
#import "HYImageLoader.h"
#import "UITools.h"

#define MaxZoomScaleNum 3.0
#define MinZoomScaleNum 1.0
#define USE_THUMBNAIL YES // 是否使用缩略图，使用了缩略图需要重新加载大图（URL）

static UIView *orginImageView = nil;
static UIView *backgroundView = nil;

@implementation HYImageBrowser
+ (void)showImage:(UIView *)avatarImageView {
    [self showImage:avatarImageView withURL:nil];
}

+ (void)showImage:(UIView *)avatarImageView withURL:(NSString *)url {
    UIImage *image = nil;
    if ([avatarImageView isKindOfClass:[UIImageView class]]) {
        image = ((UIImageView *)avatarImageView).image;
    } else
    {
        image = [UITools snapImageForView:avatarImageView];
    }
    orginImageView = avatarImageView;
    orginImageView.alpha = 1;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    CGRect oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    backgroundView.alpha=0;
    
    NSLog(@"oldframe:%@", NSStringFromCGRect(oldframe));
    HYPhotoView *photoView = [[HYPhotoView alloc] initWithFrame:oldframe andImage:image];
    photoView.autoresizingMask = (1 << 6) -1;
    photoView.tag = 1;
    
    //    UIImageView *imageView=[[UIImageView alloc] initWithFrame:oldframe];
    //    imageView.image=image;
    //    imageView.tag=1;
    //    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    imageView.clipsToBounds = YES;
    //[scrollView addSubview:imageView];
    
    [backgroundView addSubview:photoView];
    [window addSubview:backgroundView];
    
    if (USE_THUMBNAIL && url) {
        [HYImageLoader setImageView:photoView.imageView
                              withURL:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                     placeholderImage:image
                         failureImage:nil
                            completed:^(UIImage *image, NSError *error, NSString *imageURL) {
                                if (!error) {
                                    NSLog(@"加载大图完成：%@", imageURL);
                                    HYPhotoView *photoView=(HYPhotoView *)[backgroundView viewWithTag:1];
                                    [photoView setImage:image];
                                }
                            }];
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
        //        photoView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        orginImageView.alpha = 1;
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)hideImage {
    if (orginImageView != nil && backgroundView != nil) {
        HYPhotoView *photoView=(HYPhotoView *)[backgroundView viewWithTag:1];
        [UIView animateWithDuration:0.3 animations:^{
            photoView.frame=[orginImageView convertRect:orginImageView.bounds toView:[UIApplication sharedApplication].keyWindow];
            orginImageView.alpha = 1;
            backgroundView.alpha=0;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            orginImageView.alpha = 1;
            backgroundView.alpha=0;
            orginImageView = nil;
            backgroundView = nil;
        }];
    }
}

@end

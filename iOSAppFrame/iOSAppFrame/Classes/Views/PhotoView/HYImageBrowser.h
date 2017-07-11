//
//  HYImageBrowser.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYImageBrowser : NSObject
+ (void)showImage:(UIView *)avatarImageView;
+ (void)showImage:(UIView*)avatarImageView withURL:(NSString *)url;
+ (void)hideImage;
@end

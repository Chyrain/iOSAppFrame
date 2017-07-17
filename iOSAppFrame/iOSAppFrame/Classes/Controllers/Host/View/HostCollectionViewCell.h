//
//  HostCollectionViewCell.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostCollectionViewCell : UICollectionViewCell

/**
 * 商品图片名字
 */
@property (nonatomic, copy) NSString *iconName;
/**
 * 商品描述
 */
@property (nonatomic, copy) NSString *describe;
/**
 * 原价
 */
@property (nonatomic, copy) NSString *originalPrice;
/**
 * 现价
 */
@property (nonatomic, copy) NSString *currentPrice;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;

@end

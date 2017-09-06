//
//  HYTransitionTool.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/11.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
// 显示封面照片的 UIImageView 的 tag.
#define HYCoverImageViewTag 100000

typedef void(^HYNoParaBlock)(void);
typedef void(^HYContainIDBlock)(id);

@interface HYTransitionTool : NSObject
/*!
 * \~chinese
 * @prama indexPath                用户选中的那个UICollectionViewCell的 indexPath.
 * @prama collectionView           用户选中的那个UICollectionViewCell的 UICollectionView.
 * @prama viewController           动画之前窗口上显示的 viewController.
 * @prama presentViewController    动画完成之后要在窗口上显示的 viewController.
 * @prama afterPresentedBlock      动画完成之后要在 presentViewController 做的事情.
 *
 * @return HYContainIDBlock        关闭动画的 block.
 */
-(HYContainIDBlock)begainAnimationWithCollectionViewDidSelectedItemIndexPath:(NSIndexPath *)indexPath collcetionView:(UICollectionView *)collectionView forViewController:(UIViewController *)viewController presentViewController:(UIViewController *)presentViewController afterPresentedBlock:(HYNoParaBlock)afterPresentedBlock;

@end

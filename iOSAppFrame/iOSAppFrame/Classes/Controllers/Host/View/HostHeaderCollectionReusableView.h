//
//  HostHeaderCollectionReusableView.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HostHeadCollectionReusableViewDelegete <NSObject>
/**
 * carouselView
 * @param indexItem index item
 */
- (void)hostHeaderScrollViewEventDidSelectIndex:(NSInteger)indexItem;
/**
 * hostHeadCollection
 * @param indexItem index item
 */
- (void)hostHeaderCollectionEventDidSelectIndex:(NSInteger)indexItem;
@end

@interface HostHeaderCollectionReusableView : UICollectionReusableView
@property (nonatomic, weak) id<HostHeadCollectionReusableViewDelegete> delegate;
@end

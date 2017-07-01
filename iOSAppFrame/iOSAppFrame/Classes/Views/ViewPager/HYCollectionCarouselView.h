//
//  HYCollectionCarouselView.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYCollectionCarouselViewDelegete <NSObject>
/**
 * selected item
 * @param indexItem index item
 */
- (void)hy_collectionCarouselViewDidSelectItem:(NSInteger )indexItem;

@end

@interface HYCollectionCarouselView : UIView

@property (nonatomic, weak) id<HYCollectionCarouselViewDelegete> delegete;
@property (nonatomic, assign) NSTimeInterval autoPlayTime;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

@end

//
//  HostSearchViewController.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/4.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "BaseViewController.h"

@protocol HostSearchViewDelegate <NSObject>

/**
 * 移除当前ViewController
 */
- (void)onSearchViewControllerDismiss;

/**
 * 搜索关键词回调
 * @param hotWordString 搜索的关键字
 */
- (void)hotWordSearchSelect:(NSString *)hotWordString;

@end

@interface HostSearchViewController : BaseViewController
/**
 * 热词搜索
 */
@property (strong, nonatomic) UICollectionView *hotWordCollectionView;
/**
 * 历史搜索
 */
@property (strong, nonatomic) UITableView *historyWordTableView;
/**
 * @param viewControllerName 在host首页H5页面跳转过来
 */
- (instancetype)initWithViewControllerName:(NSString *)viewControllerName;
/**
 * 当前页面代理
 */
@property(assign, nonatomic) id<HostSearchViewDelegate> delegate;

@end

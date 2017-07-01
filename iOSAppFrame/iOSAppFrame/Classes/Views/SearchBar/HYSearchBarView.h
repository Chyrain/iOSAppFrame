//
//  HYSearchBarView.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSearchBar.h"

/**
 * 自定义搜索右边按钮协议HYSearchBarViewDelegate
 */
@protocol HYSearchBarViewDelegate<NSObject>

/**
 * 语音识别回调
 */
- (void)hy_onSearchVoiceResult:(NSString *)resultStr; // 返回语音搜索关键字

/**
 * 搜索框中右端事件
 */
- (void)hy_rightBtnActionSearchBarV:(UIButton *)sender;

@optional

- (BOOL)hy_searchBarViewShouldBeginEditing:(UISearchBar *)searchBar;                      // return NO to not become first responder

- (void)hy_searchBarViewTextDidBeginEditing:(UISearchBar *)searchBar;                     // called when text starts editing

- (BOOL)hy_searchBarViewShouldEndEditing:(UISearchBar *)searchBar;                        // return NO to not resign first responder

- (void)hy_searchBarViewTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing

- (void)hy_searchBarView:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)

- (BOOL)hy_searchBarView:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; // called before text changes

- (void)hy_searchBarViewSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)hy_searchBarViewBookmarkButtonClicked:(UISearchBar *)searchBar;                   // called when bookmark button pressed

- (void)hy_searchBarViewCancelButtonClicked:(UISearchBar *)searchBar;                     // called when cancel button pressed

- (void)hy_searchBarViewResultsListButtonClicked:(UISearchBar *)searchBar;                // called when search results button pressed

- (void)hy_searchBarView:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope;

@end


/***************************EVNSearchBarView*******************************
 * 如果将HYSearchBarView加到导航栏有两种方式
 * 1、[self.navigationController.navigationBar addSubview:self.searchBarView];
 * 2、 self.navigationItem.titleView = self.searchBarView;
 * 如果使用方式1的话，记得在viewDidDisappear方法中
 * 移除[self.searchBarView removeFromSuperview];
 */

/**
 * 自定义搜索右边按钮样式搜索框
 */

@interface HYSearchBarView:UIView <UISearchBarDelegate, HYSearchBarDelegate>

@property (strong, nonatomic) HYSearchBar *searchBar;

@property (strong, nonatomic) UIButton *rightButton;

@property (weak, nonatomic) id<HYSearchBarViewDelegate> searchBarViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame andWithRightBtnTitle:(NSString *)title andWithRightBtnImage:(NSString *)rightImageName;


@end

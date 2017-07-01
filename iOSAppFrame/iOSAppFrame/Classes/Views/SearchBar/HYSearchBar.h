//
//  HYSearchBar.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYSearchBarDelegate<NSObject>

@optional
/**
 * 语音识别回调
 * @param resultStr 返回语音搜索关键字
 */
- (void)hy_onVoiceResult:(NSString *)resultStr;

/**
 * 取消事件
 */
- (void)hy_searchBarCancelButtonClicked:(UISearchBar *)searchBar;

/**
 * 搜索框中右端事件
 */
- (void)hy_searchBarBookmarkButtonClicked:(UISearchBar *)searchBar; // called when bookmark button pressed

/**
 * 搜索事件
 */
- (void)hy_searchBarSearchButtonClicked:(UISearchBar *)searchBar;

/**
 * 搜索框内容变化时回调
 * @param result 输入框内容
 */
- (void)hy_searchBarSearchResult:(NSString *) result;

/**
 * 激活搜索框
 * @param searchBar 搜索框
 * @return 是否激活
 */
- (BOOL)hy_searchBarShouldBeginEditing:(UISearchBar *)searchBar; // return NO to not become first responder

@end

@interface HYSearchBar : UISearchBar<UISearchBarDelegate>//, IFlyRecognizerViewDelegate>
@property (assign, nonatomic) BOOL isShowCancel;
//@property (strong, nonatomic) IFlyRecognizerView *iflyRecognizerView;
@property (strong, nonatomic) UITextField *searchBarTextField;
@property (weak, nonatomic) id<HYSearchBarDelegate> searchBarDelegate;

- (instancetype)initWithFrame:(CGRect)frame withShowCancelBtn:(BOOL)isShowCancelBtn;
@end

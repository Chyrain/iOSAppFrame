//
//  HYSearchBarView.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYSearchBarView.h"

@implementation HYSearchBarView

#pragma mark - init & life

- (instancetype)initWithFrame:(CGRect)frame andWithRightBtnTitle:(NSString *)title andWithRightBtnImage:(NSString *)rightImageName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        _searchBar = [[HYSearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height) withShowCancelBtn:NO];
        
        _searchBar.searchBarDelegate = self;
        _searchBar.delegate = self;
        
        [self addSubview:_searchBar];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (rightImageName != nil) {
            _rightButton.frame = CGRectMake(CGRectGetMaxX(self.searchBar.frame) + 7, 7, 30, 30); // 图片
        } else {
            _rightButton.frame = CGRectMake(CGRectGetMaxX(self.searchBar.frame) + 7, 7, 44*ScreenScaleX, 30); // 文字取消等
        }
        _rightButton.backgroundColor = [UIColor clearColor];
        [_rightButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitle:title  forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:rightImageName] forState:UIControlStateNormal];
        
        [self addSubview:_rightButton];
    }
    return self;
}

- (void)dealloc
{
    self.searchBar.searchBarDelegate = nil;
}

#pragma mark - IFlySpeechRecognizerDelegate && IFlyRecognizerViewDelegate 科大讯飞
- (void)onVoiceResult:(NSString *)resultStr // 返回语音搜索关键字
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_onSearchVoiceResult:)]) {
        [self.searchBarViewDelegate hy_onSearchVoiceResult:resultStr];
    }
}

#pragma mark - 右边的取消或者其他按钮
- (void)rightButtonAction:(UIButton *)sender
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
    
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_rightBtnActionSearchBarV:)]) {
        [self.searchBarViewDelegate hy_rightBtnActionSearchBarV:sender];
    }
}

#pragma mark - UISearchBarDelegate 代理方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarViewShouldBeginEditing:)]) {
        return [self.searchBarViewDelegate hy_searchBarViewShouldBeginEditing:searchBar];
    }
    return YES;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarViewTextDidBeginEditing:)]) {
        return [self.searchBarViewDelegate hy_searchBarViewTextDidBeginEditing:searchBar];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarViewShouldEndEditing:)]) {
        return [self.searchBarViewDelegate hy_searchBarViewShouldEndEditing:searchBar];
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarViewTextDidEndEditing:)]) {
        return [self.searchBarViewDelegate hy_searchBarViewTextDidEndEditing:searchBar];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarView:textDidChange:)]) {
        return [self.searchBarViewDelegate hy_searchBarView:searchBar textDidChange:searchText];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0)
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarView: shouldChangeTextInRange: replacementText:)]) {
        [self.searchBarViewDelegate hy_searchBarView:searchBar shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarViewSearchButtonClicked:)]) {
        [self.searchBarViewDelegate hy_searchBarViewSearchButtonClicked:searchBar];
    }
}

// 语音识别
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED
{
    NSLog(@"启动识别服务");
    if ([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
    
    //    if ([EVNAuthorization authorizationAVAudioSession]) {
    //        // 启动识别服务
    //        [self.searchBar.iflyRecognizerView start];
    //        if ([self.evnSearchBarViewDelegate respondsToSelector:@selector(evnSearchBarViewBookmarkButtonClicked:)]) {
    //            [self.evnSearchBarViewDelegate evnSearchBarViewBookmarkButtonClicked:searchBar];
    //        }
    //    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarViewCancelButtonClicked:)]) {
        [self.searchBarViewDelegate hy_searchBarViewCancelButtonClicked:searchBar];
    }
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarViewResultsListButtonClicked:)]) {
        [self.searchBarViewDelegate hy_searchBarViewResultsListButtonClicked:searchBar];
    }
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0)
{
    if ([self.searchBarViewDelegate respondsToSelector:@selector(hy_searchBarView:selectedScopeButtonIndexDidChange:)]) {
        [self.searchBarViewDelegate hy_searchBarView:searchBar selectedScopeButtonIndexDidChange:selectedScope];
    }
}


@end

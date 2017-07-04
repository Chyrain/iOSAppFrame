//
//  HYSearchBar.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYSearchBar.h"
#import "Utils.h"
#import "UITools.h"

#define SearchBarTextColor RGBACOLOR(93, 95, 106, 1.0)

@implementation HYSearchBar

#pragma mark - init & life

- (instancetype)initWithFrame:(CGRect)frame withShowCancelBtn:(BOOL)isShowCancelBtn {
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlaceholder:LocalStr(@"search", @"搜索")]; // 搜索框的占位符
        [self setShowsBookmarkButton:YES];
        // [self setBarStyle:UIBarStyleDefault]; // 搜索框样式
        [self setTintColor:NAV_TINT_COLOR]; // 搜索框的颜色，当设置此属性时，barStyle将失效
        
        //[self setKeyboardType:UIKeyboardTypeEmailAddress];            // 设置键盘样式
        _isShowCancel = YES;//isShowCancelBtn;
        [self setShowsCancelButton:isShowCancelBtn animated:YES];
        
        // 是否提供自动修正功能（这个方法一般都不用的）
        // [self setSpellCheckingType:UITextSpellCheckingTypeYes]; // 设置自动检查的类型
        // [self setAutocorrectionType:UITextAutocorrectionTypeDefault]; // 是否提供自动修正功能，一般设置为UITextAutocorrectionTypeDefault
        
        self.delegate = self; // 设置代理
        [self sizeToFit];
        
        [self setImage:ImageWithName(@"speak.png") forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal]; // 修改输入框右端图片Bookmark的图标
        
        self.backgroundImage = [UITools imageWithColor:[UIColor clearColor] size:self.bounds.size]; // 清空searchBar的背景色
        
        for (UIView* subview in [[self.subviews lastObject] subviews]) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *cancelBtn = (UIButton*)subview;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancelBtn setTitleColor:SearchBarTextColor forState:UIControlStateNormal];
            }
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField*)subview;
                textField.textColor = [UIColor darkTextColor]; //修改输入字体的颜色
                [textField setBackgroundColor:[UITools colorWithHexString:@"#e5e5e5"]]; // 修改输入框的颜色
                [textField setValue:SearchBarTextColor forKeyPath:@"_placeholderLabel.textColor"]; //修改placeholder的颜色
                _searchBarTextField = textField;
            } else if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview removeFromSuperview];
            }
        }
    }
    return self;
}

- (void)dealloc
{
    self.searchBarDelegate = nil;
}

#pragma mark - UISearchBarDelegate 代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    if (_isShowCancel) {
//        [searchBar setShowsCancelButton:YES animated:YES];
//        for (UIView* subview in [[self.subviews lastObject] subviews]) {
//            if ([subview isKindOfClass:[UIButton class]]) {
//                UIButton *cancelBtn = (UIButton*)subview;
//                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//                [cancelBtn setTitleColor:SearchBarTextColor forState:UIControlStateNormal];
//            }
//        }
//    }
    
    //NSLog(@"searchText = %@",searchText);
    if([self.searchBarDelegate respondsToSelector:@selector(hy_searchBarSearchResult:)]) {
        [self.searchBarDelegate hy_searchBarSearchResult:searchText];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    if (_isShowCancel) {
//        [searchBar setShowsCancelButton:YES animated:YES];
//        for (UIView* subview in [[self.subviews lastObject] subviews]) {
//            if ([subview isKindOfClass:[UIButton class]]) {
//                UIButton *cancelBtn = (UIButton*)subview;
//                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//                [cancelBtn setTitleColor:SearchBarTextColor forState:UIControlStateNormal];
//            }
//        }
//    }
    
    if ([self.searchBarDelegate respondsToSelector:@selector(hy_searchBarShouldBeginEditing:)]) {
        return [self.searchBarDelegate hy_searchBarShouldBeginEditing:searchBar];
    }
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar{
    if (_isShowCancel) {
        [searchBar setShowsCancelButton:YES animated:YES];
        
        UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        //[btn setTitleColor:SearchBarTextColor forState:UIControlStateNormal];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar   // called when cancel button pressed
{
    if (_isShowCancel) {
        [searchBar setShowsCancelButton:NO animated:YES];
    }
    if ([self.searchBarDelegate respondsToSelector:@selector(hy_searchBarCancelButtonClicked:)]) {
        [self.searchBarDelegate hy_searchBarCancelButtonClicked:searchBar];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if ([self.searchBarDelegate respondsToSelector:@selector(hy_searchBarSearchButtonClicked:)]) {
        [self.searchBarDelegate hy_searchBarSearchButtonClicked:searchBar];
    }
}

#pragma mark: 语音识别部分
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"启动识别服务");
    if ([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
    //    if ([EVNAuthorization authorizationAVAudioSession]) {
    //        // 启动识别服务
    //        [self.iflyRecognizerView start];
    //
    //        if ([self.evnSearchBarDelegate respondsToSelector:@selector(evnSearchBarBookmarkButtonClicked:)]) {
    //            [self.evnSearchBarDelegate evnSearchBarBookmarkButtonClicked:searchBar];
    //        }
    //    }
}

#pragma mark - searchBar的代理方法
#pragma mark: IFlySpeechRecognizerDelegate && IFlyRecognizerViewDelegate 科大讯飞

//- (void)onError:(IFlySpeechError *)error
//{
//    [[BaiduMobStat defaultStat] logEvent:@"10047" eventLabel:@"搜索"]; // 百度自定义事件统计
//    if (error.errorCode == 0 )
//    {
//        // [DCFStringUtil showNotice:@"未能识别您说的商品"];
//    }
//    [self.iflyRecognizerView cancel];
//}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast // 返回搜索关键字
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
}

@end

//
//  HYTabBar.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/3.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HYTabBar.h"
#import "FindViewController.h"
#import "XLBubbleTransition.h"
#import "UITools.h"

@interface HYTabBar () {
    UITabBarController *_tabVC;
}
@end

@implementation HYTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //[self setShadowImage:[UITools imageWithColor:[UIColor clearColor]]];
        NSLog(@"HYTabBar initWithFrame");
        [self addSubview:self.centerBtn];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTabVC:(UITabBarController *)tabVC
{
    if (self = [self initWithFrame:frame]) {
        _tabVC = tabVC;
    }
    return self;
}

#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.items.count > 2 && self.items.count % 2 == 1) {//大于2的奇数个子View，将中间的View改为用大按钮
        //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
        Class class = NSClassFromString(@"UITabBarButton");
        int btnIndex = 0;
        for (UIView *btn in self.subviews) {
            if ([btn isKindOfClass:class]) {
                if (btn.subviews) {
                    for (UIView *sub in btn.subviews) {
                        if ([sub isKindOfClass:[UIImageView class]]) {
                             if (btnIndex == self.items.count/2) {
                                 sub.hidden = YES;
                             } else {
                                 sub.hidden = NO;
                             }
                        }
                    }
                }
                btnIndex++;
            }
        }
        [self updateCenterBtnByTabItem:self.items[self.items.count/2]];
        [self bringSubviewToFront:self.centerBtn];
    }
}


#pragma mark - Create a custom UIButton

- (UIButton *)centerBtn
{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn addTarget:self action:@selector(centerBtn:) forControlEvents:UIControlEventTouchUpInside];
        _centerBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        _centerBtn.frame = CGRectMake(0, 0, 60, 60); //  设定button大小为适应图片
        _centerBtn.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - TAB_CENTER_BTN_MARGIN_BOTTOM);
    }
    return _centerBtn;
}

- (void)updateCenterBtnByTabItem:(UITabBarItem *)item
{
    self.centerBtn.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - TAB_CENTER_BTN_MARGIN_BOTTOM);
    [self.centerBtn setImage:item.image forState:UIControlStateNormal];
    [self.centerBtn setImage:item.selectedImage forState:UIControlStateSelected];
}

- (void)centerBtn:(UIButton *)sender {
    // 有则调用自定义的处理方法，否则为选择对应tabitem的ViewController
    if (self.hy_delegate && [self.hy_delegate respondsToSelector:@selector(hy_tabBarCenterBtnClick:)]) {
        [self.hy_delegate hy_tabBarCenterBtnClick:self];
    } else if (_tabVC) {
        [_tabVC setSelectedIndex:self.items.count/2];
    }
}

#pragma mark - 

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.centerBtn];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ([self.centerBtn pointInside:newP withEvent:event]) {
            return self.centerBtn;
        } else {//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    } else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end

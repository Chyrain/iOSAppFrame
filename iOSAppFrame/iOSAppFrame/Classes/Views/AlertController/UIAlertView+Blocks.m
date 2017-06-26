//
//  UIAlertView+Blocks.m
//  AlertController
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "UIAlertView+Blocks.h"

#import <objc/runtime.h>

static char UIAlertViewDelegateKey;

static char UIAlertViewDidPresentBlockKey;
static char UIAlertViewClickedButtonBlockKey;

@interface UIAlertView () <UIAlertViewDelegate>

@end

@implementation UIAlertView (Blocks)

- (void)checkDelegate
{
    if (self.delegate != self) {
        objc_setAssociatedObject(self, &UIAlertViewDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = self;
    }
}

- (id<UIActionSheetDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &UIAlertViewDelegateKey);
}

#pragma mark -

- (AlertViewBlock)didPresentBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewDidPresentBlockKey);
}

- (void)setDidPresentBlock:(AlertViewBlock)didPresentBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIAlertViewDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (AlertViewCompletionBlock)clickedButtonBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewClickedButtonBlockKey);
}

- (void)setClickedButtonBlock:(AlertViewCompletionBlock)clickedButtonBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIAlertViewClickedButtonBlockKey, clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    AlertViewBlock block = self.didPresentBlock;
    if (block)
        block(alertView);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(didPresentAlertView:)])
        [originalDelegate didPresentAlertView:alertView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertViewCompletionBlock block = self.clickedButtonBlock;
    if (block)
        block(alertView, buttonIndex);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
}

@end

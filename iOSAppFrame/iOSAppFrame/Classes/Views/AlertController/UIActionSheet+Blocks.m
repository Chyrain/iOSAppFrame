//
//  UIActionSheet+Blocks.m
//  AlertController
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "UIActionSheet+Blocks.h"

#import <objc/runtime.h>

static char UIActionSheetDelegateKey;

static char UIActionSheetDidPresentBlockKey;
static char UIActionSheetClickedButtonBlockKey;

@interface UIActionSheet () <UIActionSheetDelegate>

@end

@implementation UIActionSheet (Blocks)

- (void)checkDelegate
{
    if (self.delegate != self) {
        objc_setAssociatedObject(self, &UIActionSheetDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = self;
    }
}

- (id<UIActionSheetDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &UIActionSheetDelegateKey);
}

#pragma mark -

- (ActionSheetBlock)didPresentBlock
{
    return objc_getAssociatedObject(self, &UIActionSheetDidPresentBlockKey);
}

- (void)setDidPresentBlock:(ActionSheetBlock)didPresentBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIActionSheetDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (ActionSheetCompletionBlock)clickedButtonBlock
{
    return objc_getAssociatedObject(self, &UIActionSheetClickedButtonBlockKey);
}

- (void)setClickedButtonBlock:(ActionSheetCompletionBlock)clickedButtonBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIActionSheetClickedButtonBlockKey, clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UIActionSheetDelegate

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    ActionSheetBlock block = self.didPresentBlock;
    if (block)
        block(actionSheet);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(didPresentActionSheet:)])
        [originalDelegate didPresentActionSheet:actionSheet];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ActionSheetCompletionBlock block = self.clickedButtonBlock;
    if (block)
        block(actionSheet, buttonIndex);

    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
        [originalDelegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
}

@end

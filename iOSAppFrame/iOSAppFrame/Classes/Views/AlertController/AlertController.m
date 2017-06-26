//
//  AlertController.m
//  AlertController
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "AlertController.h"

#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

#pragma mark - AlertAction

@interface AlertAction ()

@property (nonatomic, copy) AlertActionHandler handler;

@end

@implementation AlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(AlertActionHandler)handler;
{
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(AlertActionHandler)handler;
{
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[AlertAction allocWithZone:zone] initWithTitle:self.title.copy style:self.style handler:self.handler];
}

@end

#pragma mark - AlertController

@interface AlertController ()

@property (nonatomic, strong) NSMutableArray *mutableActions;
@property (nonatomic, strong) NSMutableArray *mutableTextFields;

@property (nonatomic, strong) NSMutableDictionary *configurationHandlers;

@end

@implementation AlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AlertControllerStyle)preferredStyle;
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AlertControllerStyle)preferredStyle;
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        
        _mutableActions = [NSMutableArray array];
        _mutableTextFields = [NSMutableArray array];
        
        _configurationHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -

- (NSArray *)actions
{
    return self.mutableActions.copy;
}

- (NSArray *)textFields
{
    return self.mutableTextFields.copy;
}

#pragma mark -

- (void)addAction:(AlertAction *)action;
{
    [self.mutableActions addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
{
    UITextField *textField = [UITextField new];
    if (configurationHandler)
        configurationHandler(textField);
    [self.mutableTextFields addObject:textField];
    
    if (configurationHandler)
        self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]] = configurationHandler;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    AlertController *alertController = [[AlertController allocWithZone:zone] initWithTitle:self.title.copy message:self.message.copy preferredStyle:self.preferredStyle];
    
    for (AlertAction *action in self.actions) {
        [alertController addAction:action.copy];
    }
    
    for (UITextField *textField in self.textFields) {
        [alertController addTextFieldWithConfigurationHandler:self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]]];
    }
    
    return alertController;
}

@end

#pragma mark - UIViewController (AlertController)

@implementation UIViewController (AlertController)

- (void)presentAlertController:(AlertController *)alertController animated:(BOOL)animated completion:(void (^)(void))completion;
{
    if ([UIAlertController class]) {
        UIAlertController *newAlertController = [UIAlertController alertControllerWithTitle:alertController.title message:alertController.message preferredStyle:(UIAlertControllerStyle)alertController.preferredStyle];
        
        for (AlertAction *action in alertController.actions) {
            UIAlertAction *newAction = [UIAlertAction actionWithTitle:action.title style:(UIAlertActionStyle)action.style handler:^(UIAlertAction *newAction) {
                if (action.handler)
                    action.handler(action);
            }];
            [newAlertController addAction:newAction];
        }
        
        for (UITextField *textField in alertController.textFields) {
            [newAlertController addTextFieldWithConfigurationHandler:^(UITextField *newTextField) {
                void (^handler)(UITextField *textField) = alertController.configurationHandlers[[NSValue valueWithNonretainedObject:textField]];
                if (handler)
                    handler(newTextField);
            }];
        }
        
        [self presentViewController:newAlertController animated:animated completion:completion];
    } else {
        if (alertController.preferredStyle == AlertControllerStyleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertController.title message:alertController.message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
            for (AlertAction *action in alertController.actions) {
                [alertView addButtonWithTitle:action.title];
                
                if (alertView.cancelButtonIndex == -1 && action.style == AlertActionStyleCancel)
                    alertView.cancelButtonIndex = alertView.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            if (alertController.textFields.count) {
                if (alertController.textFields.count == 1) {
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    
                    UITextField *textField = [alertView textFieldAtIndex:0];
                    alertController.mutableTextFields = [NSMutableArray arrayWithObject:textField];
                } else {
                    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                    
                    UITextField *firstTextField = [alertView textFieldAtIndex:0];
                    UITextField *secondTextField = [alertView textFieldAtIndex:1];
                    alertController.mutableTextFields = [NSMutableArray arrayWithObjects:firstTextField, secondTextField, nil];
                }
            }
            
            alertView.didPresentBlock = ^(UIAlertView *alertView){
                if (completion)
                    completion();
            };
            
            alertView.clickedButtonBlock = ^(UIAlertView *alertView, NSInteger buttonIndex){
                AlertAction *action = alertController.actions[buttonIndex];
                if (action.handler)
                    action.handler(action);
            };
            
            [alertView show];
        } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:alertController.title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for (AlertAction *action in alertController.actions) {
                [actionSheet addButtonWithTitle:action.title];
                
                if (actionSheet.cancelButtonIndex == -1 && action.style == AlertActionStyleCancel)
                    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                if (actionSheet.destructiveButtonIndex == -1 && action.style == AlertActionStyleDestructive)
                    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            actionSheet.didPresentBlock = ^(UIActionSheet *actionSheet){
                if (completion)
                    completion();
            };
            
            actionSheet.clickedButtonBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                AlertAction *action = alertController.actions[buttonIndex];
                if (action.handler)
                    action.handler(action);
            };
            
            [actionSheet showInView:self.view];
        }
    }
}

@end

//
//  兼容iOS7的UIAlertView和UIActionSheet，iOS8及以上使用UIAlertController
//
//  AlertController.h
//  AlertController
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertActionStyle) {
    AlertActionStyleDefault = 0,
    AlertActionStyleCancel,
    AlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, AlertControllerStyle) {
    AlertControllerStyleActionSheet = 0,
    AlertControllerStyleAlert
};

@class AlertAction;

typedef void (^AlertActionHandler)(AlertAction *action);

typedef void (^AlertControllerCompletionBlock)(id sender, NSInteger buttonIndex);

#pragma mark - AlertAction

@interface AlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(AlertActionHandler)handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) AlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

#pragma mark - AlertController

@interface AlertController : NSObject <NSCopying>

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AlertControllerStyle)preferredStyle;

- (void)addAction:(AlertAction *)action;
@property (nonatomic, readonly) NSArray *actions;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
@property (nonatomic, readonly) NSArray *textFields;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) AlertControllerStyle preferredStyle;

@end

#pragma mark - UIViewController (AlertController)

@interface UIViewController (AlertController)

- (void)presentAlertController:(AlertController *)alertController animated:(BOOL)animated completion:(void (^)(void))completion;

@end

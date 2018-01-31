//
//  BBSingleLinkedNode.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/10/17.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 链表节点 */
@interface BBSingleLinkedNode : NSObject <NSCopying>
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) BBSingleLinkedNode *next;
- (instancetype)initWithKey:(NSString *)key
                      value:(NSString *)value;
+ (instancetype)nodeWithKey:(NSString *)key
                      value:(NSString *)value;
@end

/* 单链表 */
@interface BBSingleLinkedList : NSObject
- (void)insertNode:(BBSingleLinkedNode *)node;
- (void)insertNodeAtHead:(BBSingleLinkedNode *)node;
- (void)insertNode:(BBSingleLinkedNode *)newNode beforeNodeForKey:(NSString *)key;
- (void)insertNode:(BBSingleLinkedNode *)newNode afterNodeForKey:(NSString *)key;
- (void)bringNodeToHead:(BBSingleLinkedNode *)node;
- (void)removeNode:(BBSingleLinkedNode *)node;
- (BBSingleLinkedNode *)nodeForKey:(NSString *)key;
- (BBSingleLinkedNode *)headNode;
- (BBSingleLinkedNode *)lastNode;
- (NSInteger)length;
- (BOOL)isEmpty;
- (void)reverse;
- (void)readAllNode;
@end


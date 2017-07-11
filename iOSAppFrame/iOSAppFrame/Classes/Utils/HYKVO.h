//
//  HYKVO.h
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/9.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HYObserverBlock)(NSDictionary *change);

@interface HYKVO : NSObject

/*block
 *
 *object:被观察者
 */
+ (id)observerForObject:(id)object
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
            changeBlock:(HYObserverBlock)block;


/*selector
 *
 *object:被观察者
 *action:-(void)targetActionCallbackForObject:(id)object keyPath:(NSString*)keyPath  change:(NSDictionary*)change
 */
+ (id)observerForObject:(id)object
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                 target:(id)target
                 action:(SEL)action;

@end

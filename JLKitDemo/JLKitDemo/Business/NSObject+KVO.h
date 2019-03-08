//
//  NSObject+KVO.h
//  low-level-analyse
//
//  Created by Wangjianlong on 2017/10/15.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JLObservingBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (KVO)

- (void)JL_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(JLObservingBlock)block;

- (void)JL_removeObserver:(NSObject *)observer forKey:(NSString *)key;


@end

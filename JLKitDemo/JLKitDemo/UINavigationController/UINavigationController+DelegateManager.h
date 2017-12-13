//
//  UINavigationController+DelegateContainer.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/12/13.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _UINavigationControllerDelegateManager : NSObject<UINavigationControllerDelegate>

@end

@interface UINavigationController (DelegateManager)

- (void)addDelegate:(id<UINavigationControllerDelegate>)delegate queue:(dispatch_queue_t )queue;

- (void)removeDelegate:(id<UINavigationControllerDelegate>)delegate queue:(dispatch_queue_t )queue;

@end

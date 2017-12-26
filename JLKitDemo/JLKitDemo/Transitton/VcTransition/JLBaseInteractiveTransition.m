//
//  JLBaseInteractiveTransition.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/26.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLBaseInteractiveTransition.h"

@implementation JLBaseInteractiveTransition

- (void)wireToViewController:(UIViewController *)viewController forOperation:(JLInteractionOperation)operation {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

@end

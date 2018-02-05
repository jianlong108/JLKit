//
//  NSData+JL.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/2/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "NSData+JL.h"

@implementation NSData (JL)

- (BOOL)isEmpty
{
    if([self isKindOfClass:[NSData class]] && (self == nil || self.length == 0))
    {
        return YES;
    }
    return NO;
}

@end

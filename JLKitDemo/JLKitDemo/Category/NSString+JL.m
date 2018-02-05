//
//  NSString+JL.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/2/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "NSString+JL.h"

@implementation NSString (JL)
- (BOOL)isEmpty
{
    if ([self isKindOfClass:[NSString class]] && (self.length == 0 || self == nil)) {
        return YES;
    }
    return NO;
}
@end

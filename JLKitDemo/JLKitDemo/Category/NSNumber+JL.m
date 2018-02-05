//
//  NSNumber+JL.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/2/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "NSNumber+JL.h"

@implementation NSNumber (JL)

- (NSString *)significantDisplayString {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    return [numberFormatter stringFromNumber:self];
}

@end

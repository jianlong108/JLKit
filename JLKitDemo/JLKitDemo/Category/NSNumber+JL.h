//
//  NSNumber+JL.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/2/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (JL)

/*
 *  @return 有效的数字字符串最多保留到小数点后2位，例如1.10->@"1.1"
 */
- (NSString *)significantDisplayString;

@end

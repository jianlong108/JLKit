//
//  NSString+JL.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/2/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (JL)

- (BOOL)isEmpty;

- (NSString *)stringByAppendingNameScale:(CGFloat)scale;

- (NSString *)stringByAppendingPathScale:(CGFloat)scale;

@end

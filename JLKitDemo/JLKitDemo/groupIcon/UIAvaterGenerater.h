//
//  UIAvaterGenerater.h
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/2.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const MTAvaterGeneraterSize NS_AVAILABLE(10_0, 8_0);
UIKIT_EXTERN NSString * const MTAvaterGeneraterOuterMargin NS_AVAILABLE(10_0, 8_0);
UIKIT_EXTERN NSString * const MTAvaterGeneraterInnerMargin NS_AVAILABLE(10_0, 8_0);
UIKIT_EXTERN NSString * const MTAvaterGeneraterInnerCornerRadious NS_AVAILABLE(10_0, 8_0);
UIKIT_EXTERN NSString * const MTAvaterGeneraterOuterCornerRadious NS_AVAILABLE(10_0, 8_0);
UIKIT_EXTERN NSString * const MTAvaterGeneraterBackgroundColorAttributeName NS_AVAILABLE(10_0, 8_0);


@interface UIAvaterGenerater : NSObject

+ (void)generateGroupImageWithImages:(NSArray <UIImage *>*)images completion:(void (^)(UIImage *image))completion;

+ (void)generateGroupImageWithImages:(NSArray <UIImage *>*)images attributes:(NSDictionary *)attributeDic completion:(void (^)(UIImage *image))completion;

+ (void)generateGroupImageWithTop9UserIds:(NSArray <NSString *>*)top9UserIds
                               completion:(void (^)(UIImage *image))completion;

+ (void)generateGroupImageWithTop9UserIds:(NSArray <NSString *>*)top9UserIds attributes:(NSDictionary *)attributeDic
                               completion:(void (^)(UIImage *image))completion;

@end

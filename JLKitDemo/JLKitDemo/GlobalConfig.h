//
//  GlobalConfig.h
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/2.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIColor * UIColorFromRGB(int rgbValue)
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                           green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                            blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                           alpha:1.0];
}

static inline BOOL String_is_invalide(NSString *str)
{
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

static inline BOOL Dictionary_is_invalide(NSDictionary *dic)
{
    if (dic == nil || dic.allKeys.count == 0 || dic.allValues.count == 0) {
        return YES;
    }
    return NO;
}

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]


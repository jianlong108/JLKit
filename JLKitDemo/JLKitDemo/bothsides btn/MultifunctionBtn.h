//
//  Multifunction.h
//  MiTalk
//
//  Created by mi on 2017/9/1.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTFunctionBtnStyle) {
    MTFunctionBtnStyleTitleRight = 0,
    MTFunctionBtnStyleTitleLeft,
    MTFunctionBtnStyleTitleTop,
    MTFunctionBtnStyleTitleBottom
    
};

@interface MultifunctionBtn : UIButton


@property (nonatomic, assign)  MTFunctionBtnStyle btnStyle;

/**副标题*/
@property (nonatomic, weak) UILabel *subTitleLabel;

@end

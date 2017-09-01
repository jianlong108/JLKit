//
//  Multifunction.h
//  MiTalk
//
//  Created by wangjianlong on 2017/9/1.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MultifunctionBtnStyle) {
    MultifunctionBtnStyleTitleRight = 0,
    MultifunctionBtnStyleTitleLeft,
    MultifunctionBtnStyleTitleTop,
    MultifunctionBtnStyleTitleBottom
    
};

@interface MultifunctionBtn : UIButton


@property (nonatomic, assign)  MultifunctionBtnStyle btnStyle;

/**副标题*/
@property (nonatomic, weak) UILabel *subTitleLabel;

@end

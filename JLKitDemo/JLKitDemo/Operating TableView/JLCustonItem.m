//
//  JLCustonItem.m
//  我的控件集合
//
//  Created by Wangjianlong on 2017/8/12.
//  Copyright © 2017年 autohome. All rights reserved.
//

#import "JLCustonItem.h"

@implementation JLCustonItem
- (NSString *)reuseableIdentierOfCell{
    return self.reuseableIdentifer;
}
- (CGFloat)heightOfCell{
    return self.cellHeight;
}
@end

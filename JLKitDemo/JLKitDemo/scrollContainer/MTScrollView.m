//
//  MTScrollView.m
//  MiTalk
//
//  Created by 王建龙 on 2017/9/6.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MTScrollView.h"

@implementation MTScrollView

@dynamic delegate;


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    BOOL tag = [touch.view isKindOfClass:[UISlider class]];
    if (tag) {
        return NO;
    }
    return  YES;
}

//解决 scrollNavigation中Tableview 滑动删除
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    
    if (self.delegate && [self.delegate canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer]) {
        return [self.delegate canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

@end

//
//  JLVerticalScrollView.m
//  JLContainer
//
//  Created by Wangjianlong on 2018/8/19.
//

#import "JLVerticalScrollView.h"

@implementation JLVerticalScrollView
@dynamic delegate;


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    BOOL tag = [touch.view isKindOfClass:[UISlider class]];
    if (tag) {
        return NO;
    }
    return  YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint speedXY = [pan velocityInView:gestureRecognizer.view];
//        {
//            if (fabs(speedXY.y) > fabs(speedXY.x)) {
//                return YES;
//            } else {
//                return NO;
//            }
//        }
//        
//    }
    return YES;
}

//解决 scrollNavigation中Tableview 滑动删除
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    
    if (self.delegate && [self.delegate canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer]) {
        return [self.delegate canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

@end

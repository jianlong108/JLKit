//
//  JLScrollView.m
//  JLContainer
//
//  Created by 王建龙 on 2017/9/6.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "JLScrollView.h"
#import <objc/runtime.h>

@implementation JLScrollView

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
    BOOL shouldBeign = YES;
    if ([self.delegate respondsToSelector:@selector(innerScrollView:gestureRecognizerShouldBegin:)]) {
        shouldBeign = [self.delegate innerScrollView:self gestureRecognizerShouldBegin:gestureRecognizer];
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint speedXY = [pan velocityInView:gestureRecognizer.view];
        if (fabs(speedXY.x) > fabs(speedXY.y)) {
            shouldBeign = shouldBeign && YES;
        } else {
            shouldBeign = shouldBeign && NO;
        }
    }
    return shouldBeign;
}

//解决 scrollNavigation中Tableview 滑动删除
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    
    if (self.delegate && [self.delegate canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer]) {
        return [self.delegate canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

@end

@implementation UIScrollView(AdjuestContentInset)


- (CGFloat)offsetOrginYForHeader
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(offsetOrginYForHeader));
    return number ? [number floatValue]:0.0;
}

- (void)setOffsetOrginYForHeader:(CGFloat)offsetOrginYForHeader
{
    objc_setAssociatedObject(self, @selector(offsetOrginYForHeader), [NSNumber numberWithFloat:offsetOrginYForHeader], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)adjuestContentInsetByMTScrollNavigationController
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(adjuestContentInsetByMTScrollNavigationController));
    
    return number ? [number boolValue]:NO;
    
}

- (void)setAdjuestContentInsetByMTScrollNavigationController:(BOOL)adjuestContentInsetByMTScrollNavigationController
{
    objc_setAssociatedObject(self, @selector(adjuestContentInsetByMTScrollNavigationController), [NSNumber numberWithBool:adjuestContentInsetByMTScrollNavigationController], OBJC_ASSOCIATION_RETAIN);
    
}

@end


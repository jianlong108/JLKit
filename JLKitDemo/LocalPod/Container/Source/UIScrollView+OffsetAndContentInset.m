//
//  UIScrollView+OffsetAndContentInset.m
//  JLContainer
//
//  Created by Wangjianlong on 2018/8/19.
//

#import "UIScrollView+OffsetAndContentInset.h"
#import <objc/runtime.h>

@implementation UIScrollView (OffsetAndContentInset)

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

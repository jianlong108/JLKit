//
//  UICollectionView+AdjustContenSize.m
//  JLContainer
//
//  Created by wangjianlong on 2018/9/26.
//

#import "UICollectionView+AdjustContenSize.h"
#import <objc/runtime.h>


@implementation UICollectionView (AdjustContenSize)

- (CGSize)minRequiredContentSize
{
    NSValue *value = objc_getAssociatedObject(self, @selector(minRequiredContentSize));
    
    return value ? [value CGSizeValue]:CGSizeZero;
    
}

- (void)setMinRequiredContentSize:(CGSize)minRequiredContentSize
{
    objc_setAssociatedObject(self, @selector(minRequiredContentSize), [NSValue valueWithCGSize:minRequiredContentSize], OBJC_ASSOCIATION_RETAIN);
    [self.collectionViewLayout invalidateLayout];
}

@end

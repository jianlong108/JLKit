//
//  UITableView+IndexBar.m
//  MiTalk
//
//  Created by 王建龙 on 2017/11/29.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "UITableView+IndexBar.h"
#import <objc/runtime.h>
#import "MTTableViewSectionIndexBar.h"


@interface SCWeakProxy : NSObject

@property (nonatomic, weak) MTTableViewSectionIndexBar *indexView;

@end
@implementation SCWeakProxy
@end

@interface UITableView () <MTTableViewSectionIndexBarDelegate>

@property (nonatomic, strong) MTTableViewSectionIndexBar *mt_indexView;

@end

@implementation UITableView (IndexBar)

#pragma mark - Swizzle Method

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledSelector:@selector(MTIndexView_didMoveToSuperview) originalSelector:@selector(didMoveToSuperview)];
        [self swizzledSelector:@selector(MTIndexView_removeFromSuperview) originalSelector:@selector(removeFromSuperview)];
    });
}

+ (void)swizzledSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma Add and Remove View

- (void)MTIndexView_didMoveToSuperview
{
    [self MTIndexView_didMoveToSuperview];
    if (self.mtSectionIndexBarDataSource.count && !self.mt_indexView && self.superview) {
        MTTableViewSectionIndexBar *indexView = [[MTTableViewSectionIndexBar alloc] initWithTableView:self configuration:self.mtSectionIndexBarConfiguration];
        indexView.translucentForTableViewInNavigationBar = self.mtSectionIndexBarTranslucentForTableViewInNavigationBar;
        indexView.delegate = self;
        indexView.dataSource = self.mtSectionIndexBarDataSource;
        [self.superview addSubview:indexView];
        
        self.mt_indexView = indexView;
    }
}

- (void)MTIndexView_removeFromSuperview
{
    if (self.mt_indexView) {
        [self.mt_indexView removeFromSuperview];
        self.mt_indexView = nil;
    }
    [self MTIndexView_removeFromSuperview];
}

#pragma mark - SCIndexViewDelegate

- (void)indexView:(MTTableViewSectionIndexBar *)indexView didSelectAtSection:(NSUInteger)section
{
    if (self.mtSectionIndexBarDelegate && [self.delegate respondsToSelector:@selector(tableView:didSelectIndexViewAtSection:)]) {
        [self.mtSectionIndexBarDelegate tableView:self didSelectIndexViewAtSection:section];
    }
}

- (NSUInteger)sectionOfIndexView:(MTTableViewSectionIndexBar *)indexView tableViewDidScroll:(UITableView *)tableView
{
    if (self.mtSectionIndexBarDelegate && [self.delegate respondsToSelector:@selector(sectionOfTableViewDidScroll:)]) {
        return [self.mtSectionIndexBarDelegate sectionOfTableViewDidScroll:self];
    } else {
        return SCIndexViewInvalidSection;
    }
}

#pragma mark - Getter and Setter

- (MTTableViewSectionIndexBar *)mt_indexView
{
    SCWeakProxy *weakProxy = objc_getAssociatedObject(self, @selector(mt_indexView));
    return weakProxy.indexView;
}

- (void)setMt_indexView:(MTTableViewSectionIndexBar *)mt_indexView
{
    if (self.mt_indexView == mt_indexView) return;
    
    SCWeakProxy *weakProxy = [SCWeakProxy new];
    weakProxy.indexView = mt_indexView;
    objc_setAssociatedObject(self, @selector(mt_indexView), weakProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MTIndexViewConfiguration *)mtSectionIndexBarConfiguration
{
    MTIndexViewConfiguration *sc_indexViewConfiguration = objc_getAssociatedObject(self, @selector(mtSectionIndexBarConfiguration));
    if (!sc_indexViewConfiguration) {
        sc_indexViewConfiguration = [MTIndexViewConfiguration configuration];
    }
    return sc_indexViewConfiguration;
}

- (void)setMtSectionIndexBarConfiguration:(MTIndexViewConfiguration *)mtSectionIndexBarConfiguration
{
    if (self.mtSectionIndexBarConfiguration == mtSectionIndexBarConfiguration) return;
    
    objc_setAssociatedObject(self, @selector(mtSectionIndexBarConfiguration), mtSectionIndexBarConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<MTTableViewSectionIndexDelegate>)mtSectionIndexBarDelegate
{
    return objc_getAssociatedObject(self, @selector(mtSectionIndexBarDelegate));
}

- (void)setMtSectionIndexBarDelegate:(id<MTTableViewSectionIndexDelegate>)mtSectionIndexBarDelegate
{
    if (self.mtSectionIndexBarDelegate == mtSectionIndexBarDelegate) return;
    
    objc_setAssociatedObject(self, @selector(mtSectionIndexBarDelegate), mtSectionIndexBarDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mtSectionIndexBarTranslucentForTableViewInNavigationBar
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(mtSectionIndexBarTranslucentForTableViewInNavigationBar));
    return number.boolValue;
}

- (void)setMtSectionIndexBarTranslucentForTableViewInNavigationBar:(BOOL)mtSectionIndexBarTranslucentForTableViewInNavigationBar
{
    if (self.mtSectionIndexBarTranslucentForTableViewInNavigationBar == mtSectionIndexBarTranslucentForTableViewInNavigationBar) return;
    
    objc_setAssociatedObject(self, @selector(mtSectionIndexBarTranslucentForTableViewInNavigationBar), @(mtSectionIndexBarTranslucentForTableViewInNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.mt_indexView.translucentForTableViewInNavigationBar = mtSectionIndexBarTranslucentForTableViewInNavigationBar;
}

- (NSArray<NSString *> *)mtSectionIndexBarDataSource
{
    return objc_getAssociatedObject(self, @selector(mtSectionIndexBarDataSource));
}

- (void)setMtSectionIndexBarDataSource:(NSArray<NSString *> *)mtSectionIndexBarDataSource
{
    if (self.mtSectionIndexBarDataSource == mtSectionIndexBarDataSource) return;
    objc_setAssociatedObject(self, @selector(mtSectionIndexBarDataSource), mtSectionIndexBarDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!mtSectionIndexBarDataSource || mtSectionIndexBarDataSource.count == 0) {
        [self.mt_indexView removeFromSuperview];
        self.mt_indexView = nil;
        return;
    }
    
    if (!self.mt_indexView && self.superview) {
        MTTableViewSectionIndexBar *indexView = [[MTTableViewSectionIndexBar alloc] initWithTableView:self configuration:self.mtSectionIndexBarConfiguration];
        indexView.translucentForTableViewInNavigationBar = self.mtSectionIndexBarTranslucentForTableViewInNavigationBar;
        indexView.delegate = self;
        [self.superview addSubview:indexView];

        self.mt_indexView = indexView;
    }
    
    self.mt_indexView.dataSource = mtSectionIndexBarDataSource.copy;
}

@end

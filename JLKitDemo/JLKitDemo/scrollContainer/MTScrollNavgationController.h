//
//  UIScrollNavgationController.h
//  MiTalk
//
//  Created by 王建龙 on 2017/9/6.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTScrollContainerViewController;

@protocol ChildViewControllerProtocol <NSObject>

@optional

- (void)childViewWillAppearInScrollNavigtionViewController:(MTScrollContainerViewController*)scrollNavigationViewController clientViewSize:(CGSize)size contentInset:(UIEdgeInsets)contentInset;


- (void)childViewWillDisAppearInScrollNavigtionViewController:(MTScrollContainerViewController*)scrollNavigationViewController;

@end


@protocol MTScrollNavigationViewControllerDataSource <NSObject>

@required

- (NSInteger)numberOfTitleInScrollNavigationViewController:(MTScrollContainerViewController *)scrollNavigationVC;


- (NSString*)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC titleForIndex:(NSInteger)index;

- (UIViewController<ChildViewControllerProtocol>*)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC childViewControllerForIndex:(NSInteger)index;


@optional

- (UIButton *)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC titleButtonForIndex:(NSInteger)index;

- (NSInteger)gapForEachItem:(MTScrollContainerViewController *)scrollNavigationVC;

- (UIView *)shadowViewForScrollNavigationViewController:(MTScrollContainerViewController *)scrollNavigationVC;

//- (UIBACKBUTTON_TYPE)backButtonTypeInNavigationViewController:(UIScrollNavigationViewController *)scrollNavigationVC;


- (UIView*)rightExtensionInNavigationViewController:(MTScrollContainerViewController *)scrollNavigationVC;

- (BOOL)scrollTitleBarEnableAutoAdjust:(MTScrollContainerViewController *)viewPager;

@end

@protocol MTScrollNavigationViewControllerDelegate <NSObject>

@optional

//解决 scrollNavigation中Tableview 滑动删除
-(BOOL)canScrollWithGesture:(UIGestureRecognizer *)gestureRecoginzer  shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

- (void)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC hasChangedSelected:(NSInteger)index;


//- (void)backButtonPressInViewController:(MTScrollNavigationViewController*)scrollNavigationVC;


-(void)scrollNavigationViewControllerDidScroll:(UIScrollView*)scrollView;

- (void)scrollNavigationViewControllerWillScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC;

@end

@interface MTScrollContainerViewController : UIViewController
/*!
 @property
 @abstract 数据源
 */
@property (nonatomic, weak) id<MTScrollNavigationViewControllerDataSource> scrollNavigationDataSource;

/*!
 @property
 @abstract 事件委托
 */
@property (nonatomic, weak) id<MTScrollNavigationViewControllerDelegate> scrollNavigationDelegate;


@property (nonatomic, strong,readonly) UIScrollView    *scrollContentView;


@property(nonatomic,assign)NSInteger lastSelectIndex;

@property(nonatomic,assign)NSInteger selectedIndex;

@end

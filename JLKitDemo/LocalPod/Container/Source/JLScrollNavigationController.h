//
//  JLScrollNavigationViewController.h
//  JLContainer
//
//  Created by wangjianlong on 2018/3/5.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLScrollTitleBar.h"
#import "JLScrollNavigationChildControllerProtocol.h"

typedef NS_ENUM(NSUInteger, JLScrollNaviContentControllerScrollStyle) {
    JLScrollNaviContentControllerScrollStyle_selfPriority,    // self.innerContentView scroll Priority High
    JLScrollNaviContentControllerScrollStyle_contentControllerPriority// self.contentController scroll Priority High..eds:when scroll down make backgroundImg bigger
} NS_ENUM_AVAILABLE_IOS(7_0);

extern CGFloat const ScrollTitleBarDefaultHeight;

@protocol JLScrollNavigationControllerDataSource <NSObject>

@required

/*!
 @method
 @abstract   标题个数回调
 @discussion 标题个数回调
 @param      scrollNavigationController 滚动导航视图控制器
 @return     标题总数
 */
- (NSInteger)numberOfTitleInScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController;

/*!
 @warnging   this method will be call more than once
 @param      scrollNavigationController 滚动导航视图控制器，子控制器需要实现ChildViewControllerDelegate委托，用于监听子视图显示前的事件回调
 @param      index 指定下标
 */
- (UIViewController<JLScrollNavigationChildControllerProtocol> *)scrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
                                                                   childViewControllerForIndex:(NSInteger)index;


@optional

//当controller无法提供标题时,会试图调用此方法再次获取title
- (NSString *)scrollNavigationController:(JLScrollNavigationController *)scrollNavigationController controllerTitleWithIndex:(NSUInteger)index;
/*!
 @method
 @abstract   获取index对应的背景色
 @param      scrollNavigationController JLScrollNavigationController
 @return     颜色
 */
- (UIColor *)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController scrollTitleBarBackgroundColorWithIndex:(NSUInteger)index;

/*!
 @method
 @abstract   获取index对应的图片
 @param      scrollNavigationController JLScrollNavigationController
 @return     img object
 */
- (UIImage *)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController scrollTitleBarBackgroundImageWithIndex:(NSUInteger)index;

/*!
 @method
 @abstract   自定义scrollTitleBar的高度
 @discussion 默认是 44 + StatusBarHeight..
 @param      scrollNavigationController MTScrollNavigationController
 @return     高度
 */
- (CGFloat)scrollTitleBarHeightOfScrollNavigationController:(JLScrollNavigationController*)scrollNavigationController;

/*!
 @method
 @abstract   自定义button的回调
 @discussion 可以传入定制的button实例作为AHScrollNavigationController的title项
 @param      scrollNavigationController AHScrollNavigationController
 @param      index 下标所属button
 @return     按钮
 */
- (UIButton *)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController
                     titleButtonForIndex:(NSInteger)index;

/*!
 @method
 @abstract   按钮间隙
 @discussion 按钮间隙,仅当scrollTitleBar中elementDisplayStyle为默认样式时才生效
 @param      scrollNavigationController AHScrollNavigationController
 @return     间隙大小
 */
- (NSInteger)gapForEachItemInTitleBarOfScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController;

/*!
 @method
 @abstract   返回导航右侧扩展区视图
 @discussion 导航右侧扩展区视图
 @param      scrollNavigationController AHScrollNavigationController
 @result     无
 */
- (UIView*)rightExtensionInNavigationViewController:(JLScrollNavigationController *)scrollNavigationController forIndex:(NSUInteger)index;


- (UIView*)leftExtensionInNavigationViewController:(JLScrollNavigationController *)scrollNavigationController forIndex:(NSUInteger)index;


/*!
 @method
 @abstract   是否根据TitleBar行宽自动适配按钮
 @discussion 是否根据TitleBar行宽自动适配按钮,如果没有实现委托方法，默认为YES
 @param      scrollNavigationController AHScrollNavigationController
 @return     状态
 */
- (BOOL)scrollTitleBarEnableAutoAdjust:(JLScrollNavigationController *)scrollNavigationController;


/*!
 @method
 @abstract   返回导航顶部扩展区视图
 @param      scrollNavigationController scrollNavigationController
 @result     无
 */
- (UIView *)headerViewForScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController;

@end



/*!
 @protocol
 @abstract 滚动导航条视图控制器事件协议
 */
@protocol JLScrollNavigationControllerDelegate <NSObject>

@optional

//解决 scrollNavigation中Tableview 滑动删除
-(BOOL)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController canScrollWithGesture:(UIGestureRecognizer *)pan shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGesture;

//询问代理,是否可以开始滑动
-(BOOL)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController gestureRecognizerShouldBegin:(UIGestureRecognizer *)pan;

/*!
 * @brief  控件滑动
 * @param scrollNavigationController  滚动导航视图控制器
 */
- (void)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController
        contentScrollViewDidScroll:(UIScrollView*)contentScrollView;

- (void)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController
contentControllerScrollViewDidScroll:(UIScrollView*)contentControllerScrollView;

/**
 点击索引事件 只有点击时才会触发...
 
 @param scrollNavigationController 滚动导航视图控制器
 */
- (void)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController
                     willShowIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex;


- (void)scrollNavigationController:(JLScrollNavigationController*)scrollNavigationController
                     didShowIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex;

- (void)headerTableViewController:(JLScrollNavigationController *)controller offsetHasReachCriticalValueWithScrollDirectionUp:(BOOL)isUp;

@end

@interface JLScrollNavigationController : UIViewController

/**顶部标题栏*/
@property (nonatomic, readonly) JLScrollTitleBar *scrollTitleBar;

/**可滑动试图区域*/
@property (nonatomic, readonly) UIScrollView    *scrollContentView;

/**选中下标 */
@property (nonatomic, readonly) NSInteger selectedIndex;

/**abstract 上一次选中的索引位置 */
@property (nonatomic, readonly) NSInteger lastPage;

/**headView是否支持滚动，默认YES支持滚动*/
@property (nonatomic, assign) BOOL headScrollEnable;

/**当底部视图区域可以滑动并且headView是否支持滚动，当滚动时TitleBar是否停留在顶部*/
@property (nonatomic, assign) BOOL hidesTitleBarWhenScrollToTop;

@property (nonatomic, assign) CGFloat scrollThresholdValue;
@property (nonatomic, assign) JLScrollNaviContentControllerScrollStyle scrollStyle;

/**顶部标题显示样式*/
@property (nonatomic, assign) JLScrollTitleBarElementStyle topTitleStyle;

/**标题正常颜色*/
@property (nonatomic, strong) UIColor *scrollTitleBarItemColor;

/**标题选中颜色*/
@property (nonatomic, strong) UIColor *scrollTitleBarItemSelectColor;

/**标题子体*/
@property (nonatomic, strong) UIFont *scrollTitleBarItemFont;

/**横条颜色*/
@property (nonatomic, strong) UIColor *scrollTitleBarLineViewSelectColor;

/**横条高度 默认为1 最大值为5,最小1*/
@property (nonatomic, assign) CGFloat scrollTitleBarLineViewHeight;
@property (nonatomic, assign) CGFloat scrollTitleBarLineViewWidth;

/** 数据源 */
@property (nonatomic, weak) id<JLScrollNavigationControllerDataSource> scrollNavigationDataSource;

/** 事件委托 */
@property (nonatomic, weak) id<JLScrollNavigationControllerDelegate> scrollNavigationDelegate;



/*!
 @property
 @abstract 根据索引位置获取对应的viewcontroller,防止外层代码出现频繁的索引越界
 @result   UIViewController,如果，没有找到，则返回nil
 */
- (UIViewController <JLScrollNavigationChildControllerProtocol>*)getViewControllerWithIndex:(NSUInteger)aIndex;

/*!
 @method
 @abstract   重新加载界面数据
 @discussion 重新加载界面数据
 */
- (void)reloadData;

/*
 * 设置默认选中页
 */
- (void)setUpDefaultSelectIndex:(NSInteger)index;

/*!
 @method
 @discussion 设置标题上方的badge显示控制
 @param      show  是否显示
 @param      index 所在title下标
 */
- (void)showBadge:(BOOL)show atIndex:(NSInteger)index;

/**
 右上角显示数字提示
 
 @param text   显示的内容
 @param index 在tab 的显示位置
 @param show  是否显示
 */
- (void)showNumAlert:(BOOL)show content:(NSString *)text atIndex:(NSInteger)index;


@end

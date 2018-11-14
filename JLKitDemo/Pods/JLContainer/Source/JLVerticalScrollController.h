//
//  JLVerticalScrollController.h
//  AFNetworking
//
//  Created by wangjianlong on 2018/8/13.
//

#import <UIKit/UIKit.h>
#import "JLScrollNavigationChildControllerProtocol.h"


@protocol JLVerticalScrollControllerDataSource;
@protocol JLVerticalScrollControllerDelegate;



@interface JLVerticalScrollController : UIViewController

/**可滑动试图区域*/
@property (nonatomic, readonly) UIScrollView    *scrollContentView;

/**选中下标 */
@property (nonatomic, readonly) NSInteger selectedIndex;

/**abstract 上一次选中的索引位置 */
@property (nonatomic, readonly) NSInteger lastPage;

/** 数据源 */
@property (nonatomic, weak) id<JLVerticalScrollControllerDataSource> dataSource;

/** 事件委托 */
@property (nonatomic, weak) id<JLVerticalScrollControllerDelegate> delegate;



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

@end

@protocol JLVerticalScrollControllerDataSource <NSObject>

@required

/*!
 @method
 @abstract   标题个数回调
 @discussion 标题个数回调
 @param      scrollNavigationController 滚动导航视图控制器
 @return     标题总数
 */
- (NSInteger)numberOfTitleInScrollNavigationController:(JLVerticalScrollController *)scrollNavigationController;

/*!
 @method
 @abstract   某个下标的子视图控制器
 @discussion 某个下标的子视图控制器
 @param      scrollNavigationController 滚动导航视图控制器，子控制器需要实现ChildViewControllerDelegate委托，用于监听子视图显示前的事件回调
 @param      index 指定下标
 @return     某个子视图控制器
 */
- (UIViewController<JLScrollNavigationChildControllerProtocol> *)scrollNavigationController:(JLVerticalScrollController *)scrollNavigationController
                                                                childViewControllerForIndex:(NSInteger)index;


@optional
/*!
 @method
 @abstract   自定义button的回调
 @discussion 可以传入定制的button实例作为AHScrollNavigationController的title项
 @param      scrollNavigationController AHScrollNavigationController
 @param      index 下标所属button
 @return     按钮
 */
- (UIButton *)scrollNavigationController:(JLVerticalScrollController*)scrollNavigationController
                     titleButtonForIndex:(NSInteger)index;

/*!
 @method
 @abstract   按钮间隙
 @discussion 按钮间隙,仅当scrollTitleBar中elementDisplayStyle为默认样式时才生效
 @param      scrollNavigationController AHScrollNavigationController
 @return     间隙大小
 */
- (NSInteger)gapForEachItemInTitleBarOfScrollNavigationController:(JLVerticalScrollController *)scrollNavigationController;

/*!
 @method
 @abstract   返回导航右侧扩展区视图
 @discussion 导航右侧扩展区视图
 @param      scrollNavigationController AHScrollNavigationController
 @result     无
 */
- (UIView*)rightExtensionInNavigationViewController:(JLVerticalScrollController *)scrollNavigationController forIndex:(NSUInteger)index;


- (UIView*)leftExtensionInNavigationViewController:(JLVerticalScrollController *)scrollNavigationController forIndex:(NSUInteger)index;


/*!
 @method
 @abstract   是否根据TitleBar行宽自动适配按钮
 @discussion 是否根据TitleBar行宽自动适配按钮,如果没有实现委托方法，默认为YES
 @param      scrollNavigationController AHScrollNavigationController
 @return     状态
 */
- (BOOL)scrollTitleBarEnableAutoAdjust:(JLVerticalScrollController *)scrollNavigationController;


/*!
 @method
 @abstract   返回导航顶部扩展区视图
 @param      scrollNavigationController scrollNavigationController
 @result     无
 */
- (UIView *)headerViewForScrollNavigationController:(JLVerticalScrollController *)scrollNavigationController;

@end

/*!
 @protocol
 @abstract 滚动导航条视图控制器事件协议
 */
@protocol JLVerticalScrollControllerDelegate <NSObject>

@optional

//解决 scrollNavigation中Tableview 滑动删除
-(BOOL)scrollNavigationController:(JLVerticalScrollController *)scrollNavigationController canScrollWithGesture:(UIGestureRecognizer *)pan shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGesture;

/*!
 * @brief  控件滑动
 * @param scrollNavigationController  滚动导航视图控制器
 */
- (void)scrollNavigationController:(JLVerticalScrollController*)scrollNavigationController
        contentScrollViewDidScroll:(UIScrollView*)contentScrollView;


/**
 点击索引事件 只有点击时才会触发...
 
 @param scrollNavigationController 滚动导航视图控制器
 */
- (void)scrollNavigationController:(JLVerticalScrollController*)scrollNavigationController
                     willShowIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex;


- (void)scrollNavigationController:(JLVerticalScrollController*)scrollNavigationController
                      didShowIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex;

@end

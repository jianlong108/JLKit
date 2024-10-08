//
//  JLScrollTitleBar.h
//  JLContainer
//
//  Created by 王建龙 on 2017/9/7.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum JLScrollTitleBarElementStyle{
    JLScrollTitleBarElementStyleDefault,
    JLScrollTitleBarElementStyleAvarge,
    JLScrollTitleBarElementStyleCenter,
}JLScrollTitleBarElementStyle;

@class JLScrollTitleBar;

@protocol JLScrollTitleBarDataSource <NSObject>
@required

- (NSInteger)numberOfTitleInScrollTitleBar:(JLScrollTitleBar *)scrollTitleBar;

@optional

- (NSString*)scrollTitleBar:(JLScrollTitleBar*)scrollTitleBar titleForIndex:(NSInteger)index;

- (UIButton *)scrollTitleBar:(JLScrollTitleBar*)scrollTitleBar titleButtonForIndex:(NSInteger)index;

- (BOOL)enableAutoAdjustWidth:(JLScrollTitleBar *)scrollTitleBar;

/*!
 @method
 @abstract   按钮间隙
 @discussion 注意⚠！ 按钮间隙,对于自定义的button是无效的，自定义的button间距需要自己设置
 @param      scrollTitleBar JLScrollTitleBar
 @return     间隙大小 如果使用自动布局（enableAutoAdjust:），此处应返回0
 */
- (NSInteger)gapForEachItem:(JLScrollTitleBar *)scrollTitleBar;

/*!
 @method
 @abstract   右部视图
 @warning    当styele 不是默认类型时,不会压缩contentscrollview的显示
 @return     返回值为 UIView的子类 会显示在滑动导航后面
 */
- (UIView *)rightViewForScrollTitleBar:(JLScrollTitleBar *)scrollTitleBar index:(NSUInteger)index;

/*!
 @method
 @abstract   左部视图...注意:当styele 不是默认类型时,不会压缩contentscrollview的显示
 @return     返回值为 UIView的子类 会显示在滑动导航后面
 */
- (UIView *)leftViewForScrollTitleBar:(JLScrollTitleBar *)scrollTitleBar index:(NSUInteger)index;


@end

@protocol JLScrollTitleBarDelegate <NSObject>

@optional

- (void)clickItem:(JLScrollTitleBar *)scrollTitleBar atIndex:(NSInteger)aIndex;

@end


@interface JLScrollTitleBar : UIView

@property (nonatomic, readonly) UIImageView  *backGroundImgView;
@property (nonatomic, readonly) UIScrollView *contentScrollView;
@property (nonatomic, readonly) UIView *rightView;
@property (nonatomic, readonly) UIView *leftView;

@property (nonatomic, weak) id<JLScrollTitleBarDataSource> dataSource;

@property (nonatomic, weak) id<JLScrollTitleBarDelegate> delegate;

@property (nonatomic, readonly) NSUInteger selectedIndex;


////默认为NO 类似于tabbar点击后会触发事件
@property (nonatomic, assign) BOOL selectedByTouchDown;

@property (nonatomic, assign) BOOL autoScroller;

//// UI
@property (nonatomic, assign) JLScrollTitleBarElementStyle  elementDisplayStyle;

@property (nonatomic, strong) UIFont *titleFont; //默认15号
@property (nonatomic, strong) UIFont *selectTitleFont; //默认15号
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *lineViewColor;
@property (nonatomic, assign) CGFloat lineViewHeight;//默认为1, 范围[1,5]
@property (nonatomic, assign) CGFloat lineViewWidth;
//底部lineview的宽度根据对应的标题宽度适应 default NO
@property (nonatomic, assign) BOOL lineViewWithtAdjustByView;
@property (nonatomic, assign) CGFloat lineViewBottomMargin;
@property (nonatomic, assign) CGFloat marginBetweenlineViewAndBtn;

////第一个按钮的X坐标 将以此坐标开始布局 JLScrollTitleBarElementStyleDefault布局时生效
@property (nonatomic, assign) CGFloat firstBtnX;

- (instancetype)initWithFrame:(CGRect)frame canScroll:(BOOL)scroll;


/**
 设置默认选中索引
 @warning 设置的默认选中的值,在reloadData调用时依然失效,如需设置新的值,需要再次调用这个方法
 @param index 索引
 */
- (void)setUpSelecteIndex:(NSUInteger)index;

- (void)selectBtnWithIndex:(NSUInteger)index;
/**
 如果数据源没有提供数据,返回NO,不做任何操作

 @return 能否刷新UI
 */
- (BOOL)reloadData;


/**
 从数据源 层面更新title
 */
- (void)updateTitleFromDataSource;



/**
 外部驱动--向另一个索引过渡

 @param toIndex 目标索引
 @param fromIndex 当前索引
 @param scale 比例
 */
- (void)scrollingToNextElement:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex scale:(CGFloat)scale;

- (void)showBadge:(BOOL)show atIndex:(NSInteger)index;

- (void)showNumAlert:(BOOL)show content:(NSString *)content atIndex:(NSInteger)index;

@end


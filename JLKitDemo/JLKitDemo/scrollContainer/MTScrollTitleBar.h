//
//  MTScrollTitleBar.h
//  MiTalk
//
//  Created by 王建龙 on 2017/9/7.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MTScrollTitleBarElementStyle{
    MTScrollTitleBarElementStyleDefault,
    MTScrollTitleBarElementStyleAvarge,
    MTScrollTitleBarElementStyleCenter,
}MTScrollTitleBarElementStyle;

@class MTScrollTitleBar;

@protocol MTScrollTitleBarDataSource <NSObject>
@required

- (NSInteger)numberOfTitleInScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar;

@optional

- (NSString*)scrollTitleBar:(MTScrollTitleBar*)scrollTitleBar titleForIndex:(NSInteger)index;

- (UIButton *)scrollTitleBar:(MTScrollTitleBar*)scrollTitleBar titleButtonForIndex:(NSInteger)index;

- (BOOL)enableAutoAdjustWidth:(MTScrollTitleBar *)scrollTitleBar;


/*!
 @method
 @abstract   设置选中后背景视图
 @discussion 设置选中后背景视图(默认为下方的滑动蓝色选中提示条)
 @param      scrollTitleBar AHScrollTitleBar
 @return     背景视图
 */
- (UIView *)shadowViewForScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar;

/*!
 @method
 @abstract   按钮间隙
 @discussion 注意⚠！ 按钮间隙,对于自定义的button是无效的，自定义的button间距需要自己设置
 @param      scrollTitleBar MTScrollTitleBar
 @return     间隙大小 如果使用自动布局（enableAutoAdjust:），此处应返回0
 */
- (NSInteger)gapForEachItem:(MTScrollTitleBar *)scrollTitleBar;

/*!
 @method
 @abstract   右部视图
 @discussion
 @param      scrollTitleBar AHScrollTitleBar
 @return     返回值为 UIView的子类 会显示在滑动导航后面
 */
//- (UIView *)rightViewForScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar;


@end

@protocol MTScrollTitleBarDelegate <NSObject>

@optional

- (void)clickItem:(MTScrollTitleBar *)scrollTitleBar atIndex:(NSInteger)aIndex;

@end


@interface MTScrollTitleBar : UIView

@property (nonatomic, strong,readonly)UIScrollView *contentScrollView;

@property(nonatomic,weak)id<MTScrollTitleBarDataSource> dataSource;

@property(nonatomic,weak)id<MTScrollTitleBarDelegate> delegate;

@property(nonatomic,assign)NSInteger selectedIndex;


/**
 默认为NO 类似于tabbar点击后会触发事件
 */
@property(nonatomic,assign)BOOL selectedByTouchDown;

@property(nonatomic,assign)BOOL autoScroller;


@property(nonatomic,assign)MTScrollTitleBarElementStyle elementDisplayStyle;

//第一个按钮的X坐标 将以此坐标开始布局
@property (nonatomic, assign)CGFloat firstBtnX;

- (instancetype)initWithFrame:(CGRect)frame canScroll:(BOOL)scroll;

- (void)selecteIndex:(NSInteger)index;

- (void)reloadData;

- (void)scrollingToNextElement:(BOOL)next scale:(CGFloat)scale;

@end

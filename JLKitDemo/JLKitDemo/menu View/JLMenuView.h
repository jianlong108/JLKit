//
//  JLMEenu.h
//  JLMenuDemo
//
//  Created by 王建龙 on 15/11/28.
//  Copyright © 2015年 AngelLL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MenuViewType) {
    MenuViewTypeTableView = 1,          //表格样式
    MenuViewTypeCollectionView = 2,     //方格样式
    MenuViewTypeCustomView = 3          //自定义内容
};
typedef NS_ENUM(NSInteger, PointDirection) {
    PointDirectionLeft = 1,          //箭头居左
    PointDirectionMiddle = 2,        //箭头居中
    PointDirectionRight = 3          //箭头居右
};
typedef NS_ENUM(NSInteger, PointAppearDirection) {
    PointAppearDirectionTop    = 1,             //箭头出现在顶部
    PointAppearDirectionBottom = 2,             //箭头出现在底部
    
//    PointAppearDirectionLeft   = 2,             //箭头出现在左部
//    PointAppearDirectionRight  = 4              //箭头出现在右部
};

typedef void(^Dismiss)(void);
@class JLMenuView;
@protocol JLMenuDataSource <NSObject>

@required

- (NSUInteger)numberOfSubmenusInCustomMenu:(JLMenuView *)menuView;

- (NSArray<NSString *> *)titleForSubmenuInCustomMenu:(JLMenuView *)menuView;

- (CGSize)contentViewSizeOfMenuView:(JLMenuView *)menuView;

@optional

- (NSArray<UIImage *> *)imageForSubmenuInCustomMenu:(JLMenuView *)menuView;
//当 此方法返回MenuViewTypeCustomView.需要实现以下方法,返回自定义的view
- (MenuViewType)menuViewType:(JLMenuView *)menuView;
- (UIView *)menuViewContentView:(JLMenuView *)menuView;


- (PointAppearDirection)menuViewPointAppearanceDirection:(JLMenuView *)menuView;
- (PointDirection)menuViewDirection:(JLMenuView *)menuView;
- (UIColor *)menuViewContentColor:(JLMenuView *)menuView;
- (UIColor *)menuViewTitleColor:(JLMenuView *)menuView;

@end
@protocol JLMenuDelegate <NSObject>
@optional
- (void)menuView:(JLMenuView *)menuView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didCloseMenu:(JLMenuView *)menuView;
@end



@interface JLMenuView : UIView


@property (nonatomic, weak) id<JLMenuDelegate> delegate;
@property (nonatomic, weak) id<JLMenuDataSource> dataSource;
- (instancetype)initWithPoint:(CGPoint)point inView:(UIView *)fromeView ;
- (void)show;
@end


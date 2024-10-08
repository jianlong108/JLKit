//
//  UIScrollView+OffsetAndContentInset.h
//  JLContainer
//
//  Created by Wangjianlong on 2018/8/19.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (OffsetAndContentInset)

@property (nonatomic,assign) CGFloat offsetOrginYForHeader;

//是否在MTScrollNavigationController中调整过ContentInset
@property (nonatomic,assign) BOOL adjuestContentInsetByMTScrollNavigationController;

@end

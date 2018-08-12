//
//  InfiniteLoopView.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/9/3.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfinitePageViewDelegate;

typedef NS_ENUM(NSUInteger, InfinitePageViewScrollDirection) {
    InfinitePageViewHorizonScrollDirection,
    InfinitePageViewVerticalScrollDirection
} NS_ENUM_AVAILABLE_IOS(8_0);

@interface InfinitePageView : UIView<UIScrollViewDelegate>

@property(nonatomic, assign) CGSize pageSize;

@property(nonatomic, assign) InfinitePageViewScrollDirection scrollDirection;

@property(nonatomic, readonly) NSUInteger currentPageIndex;

@property(nonatomic, weak) id<InfinitePageViewDelegate> delegate;

- (void)addPageView:(UIView *)pageView;

- (void)scrollToPreviousPage;

- (void)scrollToNextPage;

@end

@protocol InfinitePageViewDelegate <NSObject>

@optional
- (void)pagingView:(InfinitePageView *)pagingView willBeginDragging:(UIScrollView *)scrollView;
- (void)pagingView:(InfinitePageView *)pagingView didScroll:(UIScrollView *)scrollView;
- (void)pagingView:(InfinitePageView *)pagingView didEndDragging:(UIScrollView *)scrollView;
- (void)pagingView:(InfinitePageView *)pagingView willBeginDecelerating:(UIScrollView *)scrollView;
- (void)pagingView:(InfinitePageView *)pagingView didEndDecelerating:(UIScrollView *)scrollView atPageIndex:(NSInteger)pageIndex;

@end

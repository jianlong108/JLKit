//
//  InfiniteLoopView.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/9/3.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "InfinitePageView.h"

@interface InfinitePageView () <
    UIGestureRecognizerDelegate
>

@property(nonatomic, assign) NSUInteger currentPageIndex;
@property(nonatomic, assign) NSUInteger lastPageIndex;

@property(nonatomic, strong) UIScrollView *innerScrollView;
@property(nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation InfinitePageView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (nil == _innerScrollView) {
        _currentPageIndex = 0;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        CGRect bounds = CGRectZero;
        bounds.size = frame.size;
        _innerScrollView = [[UIScrollView alloc] initWithFrame:bounds];
        _innerScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _innerScrollView.delegate = self;
        _innerScrollView.backgroundColor = [UIColor clearColor];
        _innerScrollView.clipsToBounds = NO;
        _innerScrollView.pagingEnabled = YES;
        _innerScrollView.scrollEnabled = YES;
        _innerScrollView.showsHorizontalScrollIndicator = NO;
        _innerScrollView.showsVerticalScrollIndicator = NO;
        _innerScrollView.scrollsToTop = NO;
        _scrollDirection = InfinitePageViewHorizonScrollDirection;
        [self addSubview:_innerScrollView];
        self.pageSize = frame.size;
    }
}

- (void)dealloc
{
    /**
     nil delegate in ARC to prevent Core Animation Retain which lead to crash if view
     that use InfinitePagingView deallocates while animating to next page.
     */
    
    _innerScrollView.delegate = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (nil != hitView) {
        return _innerScrollView;
    }
    return nil;
}

#pragma mark - Public methods

- (void)addPageView:(UIView *)pageView
{
    if (nil == _pageViews) {
        _pageViews = [NSMutableArray array];
    }
    [_pageViews addObject:pageView];
    [self layoutPages];
}

- (void)scrollToPreviousPage
{
    [self scrollToDirection:1 animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:_innerScrollView afterDelay:0.5f]; // delay until scroll animation end.
}

- (void)scrollToNextPage
{
    [self scrollToDirection:-1 animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:_innerScrollView afterDelay:0.5f]; // delay until scroll animation end.
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutPages];
}

#pragma mark - Private methods

- (void)layoutPages
{
    if (_scrollDirection == InfinitePageViewHorizonScrollDirection) {
        CGFloat left_margin = (self.frame.size.width - _pageSize.width) / 2;
        _innerScrollView.frame = CGRectMake(left_margin, 0.f, _pageSize.width, self.frame.size.height);
        _innerScrollView.contentSize = CGSizeMake(self.frame.size.width * _pageViews.count, self.frame.size.height);
    } else {
        CGFloat top_margin  = (self.frame.size.height - _pageSize.height) / 2;
        _innerScrollView.frame = CGRectMake(0.f, top_margin, self.frame.size.width, _pageSize.height);
        _innerScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * _pageViews.count);
    }
    NSUInteger idx = 0;
    for (UIView *pageView in _pageViews) {
        if (_scrollDirection == InfinitePageViewHorizonScrollDirection) {
            pageView.center = CGPointMake(idx * (_innerScrollView.frame.size.width) + (_innerScrollView.frame.size.width / 2), _innerScrollView.center.y);
        } else {
            pageView.center = CGPointMake(_innerScrollView.center.x, idx * (_innerScrollView.frame.size.height) + (_innerScrollView.frame.size.height / 2));
        }
        [_innerScrollView addSubview:pageView];
        idx++;
    }
    
    _lastPageIndex = floor(_pageViews.count / 2);
    if (_scrollDirection == InfinitePageViewHorizonScrollDirection) {
        _innerScrollView.contentSize = CGSizeMake(_pageViews.count * _innerScrollView.frame.size.width, self.frame.size.height);
        _innerScrollView.contentOffset = CGPointMake(_pageSize.width * _lastPageIndex, 0.f);
    } else {
        _innerScrollView.contentSize = CGSizeMake(_innerScrollView.frame.size.width, _pageSize.height * _pageViews.count);
        _innerScrollView.contentOffset = CGPointMake(0.f, _pageSize.height * _lastPageIndex);
    }
}

- (void)scrollToDirection:(NSInteger)moveDirection animated:(BOOL)animated
{
    CGRect adjustScrollRect;
    if (_scrollDirection == InfinitePageViewHorizonScrollDirection) {
        if (0 != fmodf(_innerScrollView.contentOffset.x, _pageSize.width)) return ;
        adjustScrollRect = CGRectMake(_innerScrollView.contentOffset.x - _innerScrollView.frame.size.width * moveDirection,
                                      _innerScrollView.contentOffset.y,
                                      _innerScrollView.frame.size.width, _innerScrollView.frame.size.height);
    } else {
        if (0 != fmodf(_innerScrollView.contentOffset.y, _pageSize.height)) return ;
        adjustScrollRect = CGRectMake(_innerScrollView.contentOffset.x,
                                      _innerScrollView.contentOffset.y - _innerScrollView.frame.size.height * moveDirection,
                                      _innerScrollView.frame.size.width, _innerScrollView.frame.size.height);
        
    }
    [_innerScrollView scrollRectToVisible:adjustScrollRect animated:animated];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(pagingView:willBeginDragging:)]) {
        [_delegate pagingView:self willBeginDragging:_innerScrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(pagingView:didScroll:)]) {
        [_delegate pagingView:self didScroll:_innerScrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_delegate respondsToSelector:@selector(pagingView:didEndDragging:)]) {
        [_delegate pagingView:self didEndDragging:_innerScrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(pagingView:willBeginDecelerating:)]) {
        [_delegate pagingView:self willBeginDecelerating:_innerScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = 0;
    if (_scrollDirection == InfinitePageViewHorizonScrollDirection) {
        pageIndex = _innerScrollView.contentOffset.x / _innerScrollView.frame.size.width;
    } else {
        pageIndex = _innerScrollView.contentOffset.y / _innerScrollView.frame.size.height;
    }
    
    NSInteger moveDirection = pageIndex - _lastPageIndex;
    
    //NSLog(@"pageIndex: %i %i %i",moveDirection, pageIndex, _lastPageIndex);
    //fails when we have : 0 1 1        2 Views
    //working good with:  1 2 1         3 Views
    
    if (moveDirection == 0) {
        //ok issue found !!!
        //when we have less than 3 views moveDirection is 0
        //oki let´s fix it.
        
        moveDirection = 1;
        
        for (NSUInteger i = 0; i < abs((int)moveDirection); ++i) {
            UIView *leftView = [_pageViews objectAtIndex:0];
            [_pageViews removeObjectAtIndex:0];
            [_pageViews insertObject:leftView atIndex:_pageViews.count];
        }
        
        return;
    } else if (moveDirection > 0.f) {
        for (NSUInteger i = 0; i < abs(moveDirection); ++i) {
            UIView *leftView = [_pageViews objectAtIndex:0];
            [_pageViews removeObjectAtIndex:0];
            [_pageViews insertObject:leftView atIndex:_pageViews.count];
        }
        pageIndex -= moveDirection;
    } else if (moveDirection < 0) {
        for (NSUInteger i = 0; i < abs(moveDirection); ++i) {
            UIView *rightView = [_pageViews lastObject];
            [_pageViews removeLastObject];
            [_pageViews insertObject:rightView atIndex:0];
        }
        pageIndex += abs(moveDirection);
    }
    if (pageIndex > _pageViews.count - 1) {
        pageIndex = _pageViews.count - 1;
    }
    
    NSUInteger idx = 0;
    for (UIView *pageView in _pageViews) {
        UIView *pageView = [_pageViews objectAtIndex:idx];
        if (_scrollDirection == InfinitePageViewHorizonScrollDirection) {
            pageView.center = CGPointMake(idx * _innerScrollView.frame.size.width + _innerScrollView.frame.size.width / 2, _innerScrollView.center.y);
        } else {
            pageView.center = CGPointMake(_innerScrollView.center.x, idx * (_innerScrollView.frame.size.height) + (_innerScrollView.frame.size.height / 2));
        }
        ++idx;
    }
    [self scrollToDirection:moveDirection animated:NO];
    
    _lastPageIndex = pageIndex;
    
    if ([_delegate respondsToSelector:@selector(pagingView:didEndDecelerating:atPageIndex:)]) {
        _currentPageIndex += moveDirection;
        if (_currentPageIndex < 0) {
            _currentPageIndex = _pageViews.count - 1;
        } else if (_currentPageIndex >= _pageViews.count) {
            _currentPageIndex = 0;
        }
        [_delegate pagingView:self didEndDecelerating:_innerScrollView atPageIndex:_currentPageIndex];
    }
}

@end

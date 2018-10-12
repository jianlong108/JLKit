//
//  InfiniteLooper.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/8/13.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "InfiniteLoops.h"
#import "UIImageView+WebCache.h"

@interface InfiniteLoops () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, assign) NSInteger curIndex;

/// scroll timer
@property (nonatomic, strong) NSTimer *scrollTimer;

/// scroll duration
@property (nonatomic, assign) NSTimeInterval scrollDuration;

@end

@implementation InfiniteLoops


#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration
{
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self setupViews];
        if (duration > 0.f) {
            self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:(self.scrollDuration = duration)
                                                                target:self
                                                              selector:@selector(scrollTimerDidFired:)
                                                              userInfo:nil
                                                               repeats:YES];
            [self.scrollTimer setFireDate:[NSDate distantFuture]];
        }
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self setupViews];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObservers];
    
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

#pragma mark - setupViews
- (void)setupViews {
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    [self placeSubviews];
}

- (void)placeSubviews {
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 30.f, CGRectGetWidth(self.bounds), 20.f);
    
    CGFloat imageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    self.leftImageView.frame    = CGRectMake(imageWidth * 0, 0, imageWidth, imageHeight);
    self.middleImageView.frame  = CGRectMake(imageWidth * 1, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(imageWidth * 3, 0);
    
    [self setScrollViewContentOffsetCenter];
}

#pragma mark - set scrollView contentOffset to center
- (void)setScrollViewContentOffsetCenter {
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
}

#pragma mark - kvo
- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurIndex];
    }
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    }
    
    return _pageControl;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_leftImageView.backgroundColor = [UIColor yellowColor];
    }
    
    return _leftImageView;
}
- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    [self.leftImageView setContentMode:contentMode];
    [self.middleImageView setContentMode:contentMode];
    [self.rightImageView setContentMode:contentMode];
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_middleImageView addGestureRecognizer:tap];
        //_middleImageView.backgroundColor = [UIColor redColor];
        _middleImageView.userInteractionEnabled = YES;
    }
    
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_rightImageView.backgroundColor = [UIColor greenColor];
    }
    
    return _rightImageView;
}


#pragma mark - setters
- (void)setImageURLStrings:(NSArray *)imageURLStrings {
    if (imageURLStrings) {
        _imageURLStrings = imageURLStrings;
        self.curIndex = 0;
        
        if (imageURLStrings.count > 1) {
            // auto scroll
            [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
            self.pageControl.numberOfPages = imageURLStrings.count;
            self.pageControl.currentPage = 0;
            self.pageControl.hidden = NO;
        } else {
            self.pageControl.hidden = YES;
            [self.leftImageView removeFromSuperview];
            [self.rightImageView removeFromSuperview];
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), 0);
        }
    }
}

- (void)setCurIndex:(NSInteger)curIndex {
    if (_curIndex >= 0) {
        _curIndex = curIndex;
        
        // caculate index
        NSInteger imageCount = self.imageURLStrings.count;
        NSInteger leftIndex = (curIndex + imageCount - 1) % imageCount;
        NSInteger rightIndex= (curIndex + 1) % imageCount;
        
        // TODO: if need use image from server, can import SDWebImage SDK and modify the codes below.
        // fill image
        NSString *imgUrl = self.imageURLStrings[leftIndex];
        if ([imgUrl containsString:@"http"]||[imgUrl containsString:@"https"]) {
            [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        }else {
            self.leftImageView.image = [UIImage imageNamed:imgUrl];
        }
        imgUrl = self.imageURLStrings[curIndex];
        if ([imgUrl containsString:@"http"]||[imgUrl containsString:@"https"]) {
            [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        }else {
            self.middleImageView.image = [UIImage imageNamed:imgUrl];
        }
        imgUrl = self.imageURLStrings[rightIndex];
        if ([imgUrl containsString:@"http"]||[imgUrl containsString:@"https"]) {
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        }else {
            self.rightImageView.image = [UIImage imageNamed:imgUrl];
        }
        
        // every scrolled, move current page to center
        [self setScrollViewContentOffsetCenter];
        
        self.pageControl.currentPage = curIndex;
    }
}

#pragma mark - caculate curIndex
- (void)caculateCurIndex {
    if (self.imageURLStrings && self.imageURLStrings.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        
        // judge critical value，first and third imageView's contentoffset
        CGFloat criticalValue = .2f;
        
        // scroll right, judge right critical value
        if (pointX > 2 * CGRectGetWidth(self.scrollView.bounds) - criticalValue) {
            self.curIndex = (self.curIndex + 1) % self.imageURLStrings.count;
        } else if (pointX < criticalValue) {
            // scroll left，judge left critical value
            self.curIndex = (self.curIndex + self.imageURLStrings.count - 1) % self.imageURLStrings.count;
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.imageURLStrings.count > 1) {
        [self.scrollTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.imageURLStrings.count > 1) {
        [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
    }
}

#pragma mark - button actions
- (void)imageClicked:(UITapGestureRecognizer *)tap {
    if (self.clickAction) {
        self.clickAction (self.curIndex);
    }
}

#pragma mark - timer action
- (void)scrollTimerDidFired:(NSTimer *)timer {
    // correct the imageview's frame, because after every auto scroll,
    // may show two images in one page
    CGFloat criticalValue = .2f;
    if (self.scrollView.contentOffset.x < CGRectGetWidth(self.scrollView.bounds) - criticalValue || self.scrollView.contentOffset.x > CGRectGetWidth(self.scrollView.bounds) + criticalValue) {
        [self setScrollViewContentOffsetCenter];
    }
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

@end

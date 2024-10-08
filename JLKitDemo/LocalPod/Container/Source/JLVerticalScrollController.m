//
//  MTVerticalScrollController.m
//  AFNetworking
//
//  Created by wangjianlong on 2018/8/13.
//

#import "JLVerticalScrollController.h"
#import "UIScrollView+OffsetAndContentInset.h"
#import "JLVerticalScrollView.h"



@interface JLVerticalScrollController ()<
JLVerticalScrollViewDelegate
>

{
    
    NSInteger             _pageCount;           //总页数
    NSInteger             _pageIndexBeforeRotation;
    NSMutableDictionary   *_childViewControllerDic;//子控件视图
}
@property (nonatomic, strong) JLVerticalScrollView    *scrollContentView;

@property (nonatomic, assign) NSInteger lastPage;
@property (nonatomic, assign) NSInteger defaultPage;
@property (nonatomic, assign) NSInteger selectedIndex;

//用于区分是点击翻页还是活动翻页
@property (nonatomic, assign) NSUInteger currentShowIndex;
@property (nonatomic, assign) NSUInteger currentWillShowIndex;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, weak) UIViewController *willShowViewController;


@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *customHeaderView;

//记录currentShowScrollView上一次的偏移量
@property (nonatomic, assign) CGFloat contentOffsetY;

//当前显示的UIScrollView
@property (nonatomic, assign) UIScrollView *currentShowScrollView;

@end


@implementation JLVerticalScrollController


#pragma mark - viewController lifecycle
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_currentShowScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollContentView removeObserver:self forKeyPath:@"contentOffset"];
    
    _currentShowScrollView = nil;
    _dataSource = nil;
    _delegate = nil;
    _scrollContentView.delegate = nil;
    _scrollContentView = nil;
//    _scrollTitleBar = nil;
    
    NSArray *subViewControllers = [_childViewControllerDic allValues];
    [subViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isViewLoaded)
        {
            [obj.view removeFromSuperview];
        }
        
        if ([obj respondsToSelector:@selector(contentScrollView)])
        {
            UIScrollView* scrollView = [(id<JLScrollNavigationChildControllerProtocol>)obj contentScrollView];
            
            if (scrollView.adjuestContentInsetByMTScrollNavigationController)
            {
                scrollView.adjuestContentInsetByMTScrollNavigationController = NO;
                
                UIEdgeInsets inset = scrollView.contentInset;
                inset.top -= self.headerView.frame.size.height;
                scrollView.contentInset = inset;
                scrollView.scrollIndicatorInsets = inset;
                scrollView.offsetOrginYForHeader = 0.0;
            }
            
        }
        
        [obj willMoveToParentViewController:nil];
        [obj removeFromParentViewController];
        
    }];
    
    [_childViewControllerDic removeAllObjects];
}

- (id)init
{
    
    self = [super init];
    if (self)
    {
        _lastPage = -1;
        _childViewControllerDic = [NSMutableDictionary dictionary];
        
        _currentWillShowIndex = MAXFLOAT;
//        _headScrollEnable = YES;
//        _hidesTitleBarWhenScrollToTop = YES;
        
    }
    return self;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIViewController *currentViewController = [self viewControllerAtIndex:_selectedIndex];
    [currentViewController beginAppearanceTransition:YES animated:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIViewController *currentViewController = [self viewControllerAtIndex: self.selectedIndex];
    
    UIScrollView *scrollView = nil;
    if (currentViewController && [currentViewController respondsToSelector:@selector(contentScrollView)])
    {
        scrollView = [(id<JLScrollNavigationChildControllerProtocol>)currentViewController contentScrollView];
        
    }
    self.currentShowScrollView = scrollView;
    
    [currentViewController endAppearanceTransition];
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UIViewController *currentViewController = [self viewControllerAtIndex: self.selectedIndex];
    [currentViewController endAppearanceTransition];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIViewController *currentViewController = [self viewControllerAtIndex: self.selectedIndex];
    [currentViewController beginAppearanceTransition:NO animated:animated];
    
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self loadContainerView];
    [self loadContentView];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    
    [self loadContentView];
    [_scrollContentView setContentOffset:CGPointMake(0,_selectedIndex * CGRectGetHeight(_scrollContentView.bounds))];
    [super viewDidLayoutSubviews];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom method
- (void)loadContainerView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.backgroundColor = [UIColor orangeColor];
    self.containerView.clipsToBounds = NO;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
    
    self.scrollContentView = [[JLVerticalScrollView alloc] initWithFrame:self.containerView.bounds];
    self.scrollContentView.showsVerticalScrollIndicator = NO;
    self.scrollContentView.showsHorizontalScrollIndicator = NO;
    self.scrollContentView.directionalLockEnabled = YES;
    self.scrollContentView.pagingEnabled = YES;
    self.scrollContentView.scrollEnabled = YES;
    self.scrollContentView.bounces = NO;
    self.scrollContentView.delegate = self;
    self.scrollContentView.scrollsToTop = NO;
//    self.scrollContentView.delaysContentTouches = NO;
    self.scrollContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollContentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.containerView addSubview:self.scrollContentView];
}


- (void)loadContentView
{
    [self layoutContainerView];
    [self loadCustomHeadViewDateSource];
    
    [self layoutScrollTitleBar];
    
    [self layoutHeaderView];
    [self layoutControllerView];
    
}

- (void)layoutScrollTitleBar
{
//    if(!self.scrollTitleBar)
//        return;
    
//    self.scrollTitleBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MTScrollTitleBarDefaultHeight);
    
//    if ([self.scrollTitleBar reloadData]) {
//        [self.scrollTitleBar setUpSelecteIndex:_selectedIndex];
//    }
    
}

- (void)layoutControllerView
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfTitleInScrollNavigationController:)])
    {
        _pageCount = [_dataSource numberOfTitleInScrollNavigationController:self];
    }
    
    CGFloat width = CGRectGetWidth(self.scrollContentView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollContentView.bounds);
    self.scrollContentView.contentSize = CGSizeMake(width,height * _pageCount);
    
    [self.scrollContentView setContentOffset:CGPointMake(0,height * _selectedIndex) animated:NO];
    
    [self endPaging];//显示当前选中视图
}

- (void)loadCustomHeadViewDateSource
{
//    if ([self.scrollNavigationDataSource respondsToSelector:@selector(headerViewForScrollNavigationController:)])
//    {
//        [self.customHeaderView removeFromSuperview];
//
//        self.customHeaderView = [self.scrollNavigationDataSource headerViewForScrollNavigationController:self];
//        self.customHeaderView.clipsToBounds = YES;
//    }
//    else
//    {
//        [self.customHeaderView removeFromSuperview];
//        self.customHeaderView = nil;
//    }
}

- (void)layoutHeaderView
{
//    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.customHeaderView.bounds) + CGRectGetHeight(self.scrollTitleBar.bounds));
//
//    self.headerView.clipsToBounds = YES;
//    self.customHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), self.customHeaderView.frame.size.height);
//
//    [self.headerView addSubview:self.customHeaderView];
//    [self.headerView addSubview:self.scrollTitleBar];
//    self.scrollTitleBar.frame = CGRectMake(0, self.customHeaderView.frame.size.height, CGRectGetWidth(self.containerView.bounds), MTScrollTitleBarDefaultHeight);
//
//
//    [self.containerView insertSubview:self.headerView aboveSubview:self.scrollContentView];
}

- (void)layoutContainerView
{
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    CGRect newFrame =  UIEdgeInsetsInsetRect(self.view.bounds, insets);
    
    if (!CGRectEqualToRect(self.containerView.frame, newFrame))
    {
        self.containerView.frame = newFrame;
        
    }
    
}

- (void)layoutSubViewController:(UIViewController *)controller WithIndex:(NSInteger)index
{
    if (!controller)
    {
        controller = _childViewControllerDic[@(index)];
    }
    
    if (controller)
    {
        
        if (![self.childViewControllers containsObject:controller])
        {
            [self addChildViewController:controller];
            [controller didMoveToParentViewController:self];
            
        }
        
        UIScrollView *scrollView = nil;
        if (controller && [controller respondsToSelector:@selector(contentScrollView)])
        {
            scrollView = [(id<JLScrollNavigationChildControllerProtocol>)controller contentScrollView];
            
        }
        
        
        if (controller.view.superview != _scrollContentView)
        {
            UIEdgeInsets inset = scrollView.contentInset;
            inset.top += self.headerView.frame.size.height;
            
            scrollView.contentInset = inset;
            scrollView.scrollIndicatorInsets = inset;
            
            if ([controller respondsToSelector:@selector(setScrollViewContentInset:)]) {
                [(id<JLScrollNavigationChildControllerProtocol>)controller setScrollViewContentInset:inset];
            }
            
            if (scrollView.contentOffset.y <= 0) {
                [scrollView setContentOffset:CGPointMake(0, -self.headerView.frame.size.height-self.headerView.frame.origin.y) animated:NO] ;
            }
            else
            {
                [scrollView setContentOffset:CGPointMake(0, MAX(scrollView.contentOffset.y , -self.headerView.frame.size.height-self.headerView.frame.origin.y)) animated:NO] ;
            }
            scrollView.scrollsToTop = NO;
            
            scrollView.adjuestContentInsetByMTScrollNavigationController = YES;
            
            [_scrollContentView addSubview:controller.view];
            
        }
        else {
            [scrollView setContentOffset:CGPointMake(0, MAX(scrollView.contentOffset.y , -self.headerView.frame.size.height-self.headerView.frame.origin.y)) animated:NO] ;
        }
        self.currentShowScrollView = scrollView;
        
        if (!CGRectEqualToRect(controller.view.frame, CGRectMake(0, CGRectGetHeight(_scrollContentView.frame) * index, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))))
        {
            [controller.view setFrame:CGRectMake(0,CGRectGetHeight(_scrollContentView.frame) * index, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))];
        }
        
//        if (!CGRectEqualToRect(controller.view.frame, CGRectMake(CGRectGetHeight(_scrollContentView.frame) * index,0, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))))
//        {
//            [controller.view setFrame:CGRectMake(0,CGRectGetHeight(_scrollContentView.frame) * index, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))];
//        }
    }
    
}


- (void)reloadData
{
    UIViewController *currentShowViewConntroller = [self viewControllerAtIndex:_selectedIndex];
    
    _pageCount = 0;
    _selectedIndex = _defaultPage;
    _lastPage = -1;
    
    self.currentShowScrollView = nil;
    if (currentShowViewConntroller)
    {
        [currentShowViewConntroller beginAppearanceTransition:NO animated:NO];
    }
    //移除掉所有的控制器视图
    [_childViewControllerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UIViewController *vc = (UIViewController*)obj;
        if(vc.isViewLoaded)
        {
            [vc.view removeFromSuperview];
        }
        
        if ([vc respondsToSelector:@selector(contentScrollView)])
        {
            UIScrollView* scrollView = [(id<JLScrollNavigationChildControllerProtocol>)vc contentScrollView];
            
            if (scrollView.adjuestContentInsetByMTScrollNavigationController)
            {
                scrollView.adjuestContentInsetByMTScrollNavigationController = NO;
                
                UIEdgeInsets inset = scrollView.contentInset;
                inset.top -= self.headerView.frame.size.height;
                scrollView.contentInset = inset;
                scrollView.scrollIndicatorInsets = inset;
                scrollView.offsetOrginYForHeader = 0.0;
                //                 [scrollView setContentOffset:CGPointMake(0, -inset.top) animated:NO];
                
                
            }
            
        }
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }];
    
    [_childViewControllerDic removeAllObjects];
    if (currentShowViewConntroller)
    {
        [currentShowViewConntroller endAppearanceTransition];
    }
//    [self.scrollTitleBar reloadData];
    [self layoutControllerView];
}

#pragma mark - get & set


- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    }
    
    return _headerView;
}


- (void)setCurrentShowScrollView:(UIScrollView *)currentShowScrollView
{
    if (_currentShowScrollView != currentShowScrollView && currentShowScrollView)
    {
        if ([_currentShowScrollView observationInfo])
        {
            [_currentShowScrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
        
        [self.view removeGestureRecognizer:_currentShowScrollView.panGestureRecognizer];
        _currentShowScrollView.offsetOrginYForHeader = self.headerView.frame.origin.y;
        _currentShowScrollView.scrollsToTop = NO;
        _currentShowScrollView = currentShowScrollView;
        _currentShowScrollView.scrollsToTop = YES;
        
        if (self.headerView.frame.origin.y != _currentShowScrollView.offsetOrginYForHeader)
        {
            [currentShowScrollView setContentOffset:CGPointMake(0, MAX(currentShowScrollView.contentOffset.y , -self.headerView.frame.size.height-self.headerView.frame.origin.y)) animated:NO] ;
            //            [_currentShowScrollView setContentOffset:CGPointMake(0,_currentShowScrollView.contentOffset.y + (_currentShowScrollView.offsetOrginYForHeader - self.headerView.frame.origin.y)) animated:NO] ;
        }
        _contentOffsetY = MAX(_currentShowScrollView.contentOffset.y,_currentShowScrollView.contentInset.top);
        [self.view addGestureRecognizer:_currentShowScrollView.panGestureRecognizer];
        
        [_currentShowScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
}


//- (MTScrollTitleBar *)scrollTitleBar
//{
//    if (_scrollTitleBar == nil)
//    {
//        _scrollTitleBar = [[MTScrollTitleBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MTScrollTitleBarDefaultHeight) canScroll:YES];
//        _scrollTitleBar.selectedTitleColor = self.scrollTitleBarItemSelectColor;
//        _scrollTitleBar.titleColor = self.scrollTitleBarItemColor;
//        _scrollTitleBar.lineViewColor = self.scrollTitleBarLineViewSelectColor;
//        _scrollTitleBar.dataSource = self;
//        _scrollTitleBar.elementDisplayStyle = self.topTitleStyle;
//        _scrollTitleBar.delegate = self;
//        //        _scrollTitleBar.showRightBorder = YES;
//        //        _scrollTitleBar.showLeftBorder = NO;//设置左侧阴影不显示
//
//    }
//    return _scrollTitleBar;
//}
//
//
//- (void)setTopTitleStyle:(MTScrollTitleBarElementStyle)topTitleStyle
//{
//    _topTitleStyle = topTitleStyle;
//    self.scrollTitleBar.elementDisplayStyle = topTitleStyle;
//}
//
//- (void)setScrollTitleBarItemColor:(UIColor *)scrollTitleBarItemColor
//{
//    _scrollTitleBarItemColor = scrollTitleBarItemColor;
//    self.scrollTitleBar.titleColor = scrollTitleBarItemColor;
//}
//
//- (void)setScrollTitleBarItemSelectColor:(UIColor *)scrollTitleBarItemSelectColor
//{
//    _scrollTitleBarItemSelectColor = scrollTitleBarItemSelectColor;
//    self.scrollTitleBar.selectedTitleColor = scrollTitleBarItemSelectColor;
//}
//
//- (void)setScrollTitleBarLineViewSelectColor:(UIColor *)scrollTitleBarLineViewSelectColor
//{
//    _scrollTitleBarLineViewSelectColor = scrollTitleBarLineViewSelectColor;
//    self.scrollTitleBar.lineViewColor = scrollTitleBarLineViewSelectColor;
//}
//
//- (void)setScrollTitleBarItemFont:(UIFont *)scrollTitleBarItemFont
//{
//    _scrollTitleBarItemFont = scrollTitleBarItemFont;
//    self.scrollTitleBar.titleFont = scrollTitleBarItemFont;
//}
//
//- (void)setScrollTitleBarLineViewHeight:(CGFloat)scrollTitleBarLineViewHeight
//{
//    if (scrollTitleBarLineViewHeight <= 5 && scrollTitleBarLineViewHeight >= 0) {
//        _scrollTitleBarLineViewHeight = scrollTitleBarLineViewHeight;
//        self.scrollTitleBar.lineViewHeight = scrollTitleBarLineViewHeight;
//    }
//
//}
//
//- (void)setScrollTitleBarLineViewWidth:(CGFloat)scrollTitleBarLineViewWidth
//{
//    _scrollTitleBarLineViewWidth = scrollTitleBarLineViewWidth;
//    self.scrollTitleBar.lineViewWidth = scrollTitleBarLineViewWidth;
//}

- (void)setUpDefaultSelectIndex:(NSInteger)index
{
    _selectedIndex = index;
    if (index < 0) {
        _selectedIndex = 0;
    }
    if (index >= [self.dataSource numberOfTitleInScrollNavigationController:self]) {
        _selectedIndex = [self.dataSource numberOfTitleInScrollNavigationController:self] - 1;
    }
    _defaultPage = _selectedIndex;
//    [self.scrollTitleBar setUpSelecteIndex:_selectedIndex];
}


#pragma mark - 辅助方法
+(void)setStatusHeight:(float) sHeight
{
//    statusHeight=sHeight;
}

-(void)changeStatus:(NSNotification *)notification
{
    CGRect rect= [[UIApplication sharedApplication] statusBarFrame];
    if (rect.size.height>=40) {
        [_scrollContentView setContentSize:CGSizeMake(_scrollContentView.contentSize.width, _scrollContentView.frame.size.height-20)];
    }
    else
    {
        [_scrollContentView setContentSize:CGSizeMake(_scrollContentView.contentSize.width, _scrollContentView.frame.size.height)];
    }
    
}


#pragma mark - MTScrollTitleBar

//- (void)showBadge:(BOOL)show atIndex:(NSInteger)index
//{
//    [self.scrollTitleBar showBadge:show atIndex:index];
//}
//
//- (void)showNumAlert:(BOOL)show content:(NSString *)text atIndex:(NSInteger)index
//{
//    [self.scrollTitleBar showNumAlert:show content:text atIndex:index];
//}
//
//- (UIView *)rightViewForScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar index:(NSUInteger)index
//{
//    if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(rightExtensionInNavigationViewController:forIndex:)]) {
//
//        UIView * tempView =  [_scrollNavigationDataSource rightExtensionInNavigationViewController:self forIndex:index];
//        return tempView;
//    }
//    return nil;
//}
//
//- (UIView *)leftViewForScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar index:(NSUInteger)index
//{
//    if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(leftExtensionInNavigationViewController:forIndex:)]) {
//
//        UIView * tempView =  [_scrollNavigationDataSource leftExtensionInNavigationViewController:self forIndex:index];
//        return tempView;
//    }
//    return nil;
//}


/*!
 @method
 @abstract   标题个数回调
 @discussion 标题个数回调
 @param      scrollTitleBar MTScrollTitleBar
 @return     标题总数
 */
//- (NSInteger)numberOfTitleInScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar
//{
//    if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(numberOfTitleInScrollNavigationController:)]) {
//        return [_scrollNavigationDataSource numberOfTitleInScrollNavigationController:self];
//    }
//    return 0;
//}

/*!
 @method
 @abstract   标题名称回调
 @discussion 标题名称回调
 @param      scrollTitleBar MTScrollTitleBar
 @param      index 下标所属标题名称
 @return     标题数组
 */
//- (NSString*)scrollTitleBar:(MTScrollTitleBar*)scrollTitleBar titleForIndex:(NSInteger)index
//{
//    UIViewController <MTScrollNavigationChildControllerProtocol>*controller = [self getViewControllerWithIndex:index];
//    if ([controller respondsToSelector:@selector(titleForScrollTitleBar)])
//    {
//        return [controller titleForScrollTitleBar];
//    }
//    return @"";
//}

/*!
 @method
 @abstract   是否根据行宽自动适配按钮
 @discussion 是否根据行宽自动适配按钮,如果没有实现委托方法，默认为YES
 @return     状态
 */
//- (BOOL)enableAutoAdjust:(MTScrollTitleBar *)viewPager
//{
//    if ([self.scrollNavigationDataSource respondsToSelector:@selector(scrollTitleBarEnableAutoAdjust:)])
//    {
//        return [self.scrollNavigationDataSource scrollTitleBarEnableAutoAdjust:self];
//    }
//    return NO;
//}



/*!
 @method
 @abstract   自定义button的回调
 @discussion 可以传入定制的button实例作为ScrollTitleBar的title项
 @param      scrollTitleBar MTScrollTitleBar
 @param      index 下标所属button
 @return     按钮
 */
//- (UIButton *)scrollTitleBar:(MTScrollTitleBar*)scrollTitleBar titleButtonForIndex:(NSInteger)index
//{
//    UIButton *button = nil;
//    if (_scrollNavigationDataSource &&
//        [_scrollNavigationDataSource respondsToSelector:@selector(scrollNavigationController:titleButtonForIndex:)])
//    {
//        button = [_scrollNavigationDataSource scrollNavigationController:self titleButtonForIndex:index];
//    }
//    return button;
//}

/*!
 @method
 @abstract   滚动标题条支持的行数
 @discussion 滚动标题条支持的行数
 @param      scrollTitleBar MTScrollTitleBar
 @return     行数
 */
//- (NSInteger)numberOfRowInScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar
//{
//    return 1;
//}

/*!
 @method
 @abstract   按钮间隙
 @discussion 按钮间隙
 @param      scrollTitleBar MTScrollTitleBar
 @return     间隙大小
 */
//- (NSInteger)gapForEachItem:(MTScrollTitleBar *)scrollTitleBar
//{
//    if (_scrollNavigationDataSource &&
//        [_scrollNavigationDataSource respondsToSelector:@selector(gapForEachItemInTitleBarOfScrollNavigationController:)])
//    {
//        return [_scrollNavigationDataSource gapForEachItemInTitleBarOfScrollNavigationController:self];
//    }
//    return 5;
//}

#pragma mark- MTScrollTitleBarDelegate

/*!
 @method
 @abstract   点击title事件
 @discussion 点击title事件 已经选中，再次点击
 @param      scrollTitleBar MTScrollTitleBar
 */
//- (void)clickItem:(MTScrollTitleBar *)scrollTitleBar atIndex:(NSInteger)aIndex
//{
//    if (self.scrollNavigationDelegate && [self.scrollNavigationDelegate respondsToSelector:@selector(scrollNavigationController:willShowIndex:toIndex:)])
//    {
//        [self.scrollNavigationDelegate scrollNavigationController:self
//                                                    willShowIndex:_selectedIndex
//                                                          toIndex:aIndex];
//    }
//
//    _selectedIndex = aIndex;
//
//    self.pageChangedByClick = YES;
//    [_scrollContentView setContentOffset:CGPointMake(CGRectGetWidth(_scrollContentView.frame) * aIndex, 0) animated:YES];
//
//
//}
-(BOOL)canScrollWithGesture:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(scrollNavigationController:canScrollWithGesture:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.delegate scrollNavigationController:self canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}


#pragma mark - 转屏

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Remember page index before rotation
    _pageIndexBeforeRotation = _selectedIndex;
    
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Perform layout
    _selectedIndex = _pageIndexBeforeRotation;
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

#pragma mark - 标题栏动画
- (void)scrollTitleBarScrollingAnimation:(UIScrollView *)scrollView{
//    CGFloat tempScale = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
//    CGFloat scale = tempScale - floorf(tempScale);
//    NSUInteger fromIndex = floorf(tempScale);
//    NSUInteger toIndex = ceilf(tempScale);
//    [self.scrollTitleBar scrollingToNextElement:toIndex fromIndex:fromIndex scale:scale];
}

#pragma mark- UIScrollViewDelegete
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageHeight = sender.frame.size.height;
    _selectedIndex = floor((sender.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollNavigationController:contentScrollViewDidScroll:)])
    {
        [self.delegate scrollNavigationController:self
                                       contentScrollViewDidScroll:sender];
    }
    
    if (!sender.dragging)
    {
        return;
    }
    
    //新增新的动画
    [self scrollTitleBarScrollingAnimation:sender];
    
    if (sender.contentOffset.y <= 0 || sender.contentOffset.y >= sender.contentSize.height - sender.frame.size.height )
    {
        
        UIViewController *controller = [self viewControllerAtIndex: _selectedIndex];
        
        
        UIScrollView *scrollView = nil;
        if (controller && [controller respondsToSelector:@selector(contentScrollView)])
        {
            scrollView = [(id<JLScrollNavigationChildControllerProtocol>)controller contentScrollView];
            
        }
        self.currentShowScrollView = scrollView;
        return;
    }
    
    if (sender.contentOffset.y > self.currentShowIndex * pageHeight)
    {
        NSUInteger jumpPageCount = ceil((sender.contentOffset.y - self.currentShowIndex * pageHeight)/pageHeight);
        
        if (self.currentWillShowIndex != self.currentShowIndex + jumpPageCount)
        {
            self.currentWillShowIndex = self.currentShowIndex + jumpPageCount;
            
            
            [self.willShowViewController endAppearanceTransition];
            [self.currentViewController endAppearanceTransition];
            
            
            self.currentShowScrollView = [(id<JLScrollNavigationChildControllerProtocol>)self.willShowViewController contentScrollView];
            
            self.willShowViewController = [self viewControllerAtIndex:self.currentWillShowIndex];
            
            [self layoutSubViewController:self.willShowViewController WithIndex:self.currentWillShowIndex];
            
            self.currentViewController = [self viewControllerAtIndex:self.currentWillShowIndex-1];
            [self.currentViewController beginAppearanceTransition:NO animated:YES];
            [self.willShowViewController beginAppearanceTransition:YES animated:YES];
            
        }
    }
    else  if (sender.contentOffset.y < self.currentShowIndex * pageHeight)
    {
        
        NSUInteger jumpPageCount = ceil((self.currentShowIndex * pageHeight - sender.contentOffset.y)/pageHeight);
        
        if (self.currentWillShowIndex != self.currentShowIndex - jumpPageCount)
        {
            self.currentWillShowIndex = self.currentShowIndex - jumpPageCount;
            
            [self.willShowViewController endAppearanceTransition];
            [self.currentViewController endAppearanceTransition];
            
            self.willShowViewController = [self viewControllerAtIndex:self.currentWillShowIndex];
            
            [self layoutSubViewController:self.willShowViewController WithIndex:self.currentWillShowIndex];
            
            self.currentViewController = [self viewControllerAtIndex:self.currentWillShowIndex+1];
            
            [self.currentViewController beginAppearanceTransition:NO animated:YES];
            [self.willShowViewController beginAppearanceTransition:YES animated:YES];
            
            
        }
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self endPaging];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endPaging];
//    [self.scrollTitleBar setUpSelecteIndex:_selectedIndex];
}

- (void)endPaging
{
    CGFloat pageHeight = self.scrollContentView.frame.size.height;
    
    _selectedIndex = floor((self.scrollContentView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    //记录下上一次的页码，如果上一次的页码与这次的相同，就不做任何操作
    if (_lastPage == _selectedIndex) {
        
        [self layoutSubViewController:self.currentViewController WithIndex:_selectedIndex];
        
        self.currentShowIndex = _selectedIndex;
        self.currentWillShowIndex = MAXFLOAT;
        
        self.currentViewController = nil;
        self.willShowViewController = nil;
        
        return;
    }
    
    //尝试从字典中读取
    UIViewController *subViewController = _childViewControllerDic[@(_selectedIndex)];
    
    UIViewController *lastViewController = _childViewControllerDic[@(_lastPage)];
    
    if (subViewController == nil)
    {
        //尝试获取一个子视图控制器
        if (_dataSource && [_dataSource respondsToSelector:@selector(scrollNavigationController:childViewControllerForIndex:)])
        {
            subViewController = [_dataSource scrollNavigationController:self
                                                            childViewControllerForIndex:_selectedIndex];
            _childViewControllerDic[@(_selectedIndex)] = subViewController;
            
            
        }
    }
    
    
    //向子控制器回调即将消失的回调
    //    if (lastViewController && [lastViewController respondsToSelector:@selector(childViewWillDisAppearInScrollNavigtionViewController:)]) {
    //
    //        [(id)lastViewController childViewWillDisAppearInScrollNavigtionViewController:self];
    //    }
    
    [self layoutSubViewController:subViewController WithIndex:_selectedIndex];
    
    //向子控制器回调即将显示的回调
    //    if (subViewController && [subViewController respondsToSelector:@selector(childViewWillAppearInScrollNavigtionViewController:)]) {
    //
    //        [(id)subViewController childViewWillAppearInScrollNavigtionViewController:self];
    //    }
    
    //回调选中项改变的回调
    if (_delegate && [_delegate respondsToSelector:@selector(scrollNavigationController:didShowIndex:toIndex:)]) {
        [_delegate scrollNavigationController:self didShowIndex:_lastPage == -1 ? 0 : _lastPage toIndex:_selectedIndex];
    }
    
    
    //移动到执行代理函数完成后记录
    _lastPage = _selectedIndex;
    
    self.currentShowIndex = _selectedIndex;
    self.currentWillShowIndex = MAXFLOAT;
    
    self.currentViewController = nil;
    self.willShowViewController = nil;
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)aIndex
{
    if (aIndex<_pageCount)
    {
        UIViewController *viewController = _childViewControllerDic[@(aIndex)];
        
        if (!viewController)
        {
            //尝试获取一个子视图控制器
            if (_dataSource && [_dataSource respondsToSelector:@selector(scrollNavigationController:childViewControllerForIndex:)])
            {
                viewController = [_dataSource scrollNavigationController:self childViewControllerForIndex:aIndex];
                _childViewControllerDic[@(aIndex)] = viewController;
            }
        }
        
        return viewController;
    }
    else
    {
        return nil;
    }
    return nil;
}

- (UIViewController <JLScrollNavigationChildControllerProtocol>*)getViewControllerWithIndex:(NSUInteger)aIndex
{
    UIViewController <JLScrollNavigationChildControllerProtocol>* controller;
    if (aIndex<_childViewControllerDic.count)
    {
        controller = _childViewControllerDic[@(aIndex)];
    }
    
    if (!controller) {
        controller = [self.dataSource scrollNavigationController:self childViewControllerForIndex:aIndex];
    }
    return controller;
}



#pragma mark- kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"])
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    [self _scrollContentViewContentOffsetDidChange:object];
    [self _currentShowContentScrollViewContentOffsetDidChange:object];
    
}

- (void)_scrollContentViewContentOffsetDidChange:(UIScrollView *)object
{
    UIScrollView *scrollView = self.scrollContentView;
    if (scrollView != object)
    {
        return;
    }
    //标题栏 做滚动动画
    [self scrollTitleBarScrollingAnimation:scrollView];
}

- (void)_currentShowContentScrollViewContentOffsetDidChange:(UIScrollView *)object
{
//    UIScrollView *scrollView = self.currentShowScrollView;
//    if (scrollView != object || !self.headScrollEnable)
//    {
//        return;
//    }
//    if (scrollView.contentOffset.y >scrollView.contentSize.height - CGRectGetHeight(scrollView.frame)) {
//        return;//屏蔽上拉加载 及上拉bounce回弹
//    }
//    CGRect headRect = self.headerView.frame;
//
//    CGFloat disY = _contentOffsetY - scrollView.contentOffset.y;
//
//    _contentOffsetY = scrollView.contentOffset.y;
//    NSInteger padding = 0;
//    if (self.hidesTitleBarWhenScrollToTop == NO) {
//        padding = CGRectGetHeight(self.scrollTitleBar.frame);
//    }
//    BOOL animated = NO;
//    if(disY < 0)//上滑
//    {
//        if (self.headerView.frame.origin.y > - (CGRectGetHeight(self.headerView.frame) - padding))
//        {
//            headRect.origin.y += disY;
//            headRect.origin.y = MAX(CGRectGetMinY(headRect), -(CGRectGetHeight(self.headerView.frame) - padding));
//        }
//        else {
//            headRect.origin.y = -(CGRectGetHeight(self.headerView.frame) - padding);
//            self.headerView.frame = headRect;
//        }
//    }
//    else if (disY >0)
//    {
//        if (_contentOffsetY <= 0 - CGRectGetHeight(self.scrollTitleBar.frame)) {
//
//            if (_contentOffsetY +_headerView.frame.origin.y < - CGRectGetHeight(self.headerView.frame)) {
//                headRect.origin.y += disY;
//                headRect.origin.y = MIN(-_contentOffsetY-CGRectGetHeight(self.headerView.frame), headRect.origin.y);//保证头部不移动超过下部视图
//            }
//        }
//        else {
//            if (headRect.origin.y <= -(CGRectGetHeight(self.headerView.frame) -CGRectGetHeight(self.scrollTitleBar.frame))) {
//                headRect.origin.y += disY;
//                headRect.origin.y = MIN(headRect.origin.y, -(CGRectGetHeight(self.headerView.frame) -CGRectGetHeight(self.scrollTitleBar.frame)));
//            }
//            else {
//                if (_contentOffsetY +_headerView.frame.origin.y < - CGRectGetHeight(self.headerView.frame)) {
//                    headRect.origin.y += disY;
//                    headRect.origin.y = MIN(-_contentOffsetY-CGRectGetHeight(self.headerView.frame), headRect.origin.y);//保证头部不移动超过下部视图
//                }
//            }
//        }
//    }
//    else {
//    }
//    [UIView animateWithDuration:animated?0.2:0 animations:^{
//        self.headerView.frame = headRect;
//    }];
}

#pragma  mark - 电池条支持

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return [_dataSource scrollNavigationController:self childViewControllerForIndex:_selectedIndex];
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return [_dataSource scrollNavigationController:self childViewControllerForIndex:_selectedIndex];
}

#pragma  mark - 导航控制器UI
- (UIViewController *)childViewControllerForAffectNavigationBar
{
    return [_dataSource scrollNavigationController:self childViewControllerForIndex:_selectedIndex];
}

@end

//
//  UIScrollNavgationController.m
//  MiTalk
//
//  Created by 王建龙 on 2017/9/6.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MTScrollNavgationController.h"
#import "MTScrollView.h"
#import "MTScrollTitleBar.h"


#define AHSNVC_ScrollSubviews_tag 6785 //滑动视图的子view tag，用于添加每个自控制器的view

@interface MTScrollContainerViewController ()
<
UIScrollViewDelegate,
MTScrollTitleBarDelegate,
MTScrollTitleBarDataSource
>

@property (nonatomic, strong,readwrite)MTScrollTitleBar *scrollTitleBar;

//总页数
@property (nonatomic, assign)  NSInteger             pageCount;
//当前页
@property (nonatomic, assign)  NSInteger             currentPage;
//子控件视图
@property (nonatomic, strong)  NSMutableDictionary   *childViewControllerDic;

@property (nonatomic, strong,readwrite) UIScrollView    *scrollContentView;

//用于区分是点击翻页还是活动翻页
@property (nonatomic, assign) BOOL pageChangedByClick;

@property (nonatomic, assign) NSUInteger currentShowIndex;

@property (nonatomic, assign) NSUInteger currentWillShowIndex;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, weak) UIViewController *willShowViewController;


@property (nonatomic, assign,getter=isFinishViewDidLoad) BOOL finishViewDidLoad;
@property (nonatomic, assign) BOOL isReloading;

@property (nonatomic, assign) NSInteger             pageIndexBeforeRotation;

/**将要拖拽时的偏移量*/
@property (nonatomic, assign)  CGFloat beginOffserX;

@end

@implementation MTScrollContainerViewController

#pragma mark - viewController lifecycle


- (void)dealloc
{
    [_scrollContentView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollNavigationDataSource = nil;
    _scrollNavigationDelegate = nil;
    _scrollContentView.delegate = nil;
    _scrollContentView = nil;
    _scrollTitleBar = nil;
    
    
    NSArray *subViewControllers = [_childViewControllerDic allValues];
    [subViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isViewLoaded)
        {
            [obj.view removeFromSuperview];
        }
        
        [obj willMoveToParentViewController:nil];
        [obj removeFromParentViewController];
        
    }];
    
    //    [_layoutViewController willMoveToParentViewController:nil];
    //    [_layoutViewController removeFromParentViewController];
    
    [_childViewControllerDic removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self reloadData];
    
    
    self.finishViewDidLoad = YES;
}
- (void)viewDidLayoutSubviews{
    
    [_scrollContentView setContentOffset:CGPointMake(_selectedIndex * _scrollContentView.bounds.size.width, _scrollContentView.contentOffset.y)];
    [self.scrollTitleBar selecteIndex:_selectedIndex];
    [super viewDidLayoutSubviews];
    _scrollTitleBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40);
    _scrollContentView.frame = CGRectMake(0, CGRectGetMaxY(self.scrollTitleBar.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.scrollTitleBar.bounds));
    _scrollContentView.contentSize = CGSizeMake(_pageCount * _scrollContentView.bounds.size.width, _scrollContentView.bounds.size.height);
    
    self.pageChangedByClick = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIViewController *currentViewController = [self viewControllerAtIndex: self.selectedIndex];
    [currentViewController beginAppearanceTransition:NO animated:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIViewController *currentViewController = [self viewControllerAtIndex: self.selectedIndex];
    [currentViewController beginAppearanceTransition:YES animated:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIViewController *currentViewController = [self viewControllerAtIndex: self.selectedIndex];
    [currentViewController endAppearanceTransition];
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UIViewController *currentViewController = [self viewControllerAtIndex: self.selectedIndex];
    [currentViewController endAppearanceTransition];
}

- (id)init{
    
    self = [super init];
    if (self)
    {
        _lastSelectIndex = -1;
        _childViewControllerDic = [NSMutableDictionary dictionary];
        
        _currentWillShowIndex = MAXFLOAT;
        //        self.style = AHScrollNavigationStyleFirstNavigation;
        
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)aIndex
{
    if (aIndex<_pageCount)
    {
        UIViewController *viewController = _childViewControllerDic[@(aIndex)];
        
        if (!viewController)
        {
            //尝试获取一个子视图控制器
            if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(scrollNavigationViewController:childViewControllerForIndex:)])
            {
                viewController = [_scrollNavigationDataSource scrollNavigationViewController:self childViewControllerForIndex:aIndex];
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
- (MTScrollTitleBar *)scrollTitleBar{
    if (_scrollTitleBar == nil) {
        _scrollTitleBar = [[MTScrollTitleBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40) canScroll:YES];
        
        
        
        //        _scrollTitleBar.boldFont = NO;
        //        _scrollTitleBar.selectedTitleColor = self.scrollTitleBarItemSelectColor;
        //        _scrollTitleBar.titleColor = self.scrollTitleBarItemColor;
        //        _scrollTitleBar.lineViewColor = self.scrollTitleBarLineViewSelectColor;
        _scrollTitleBar.dataSource = self;
        //        _scrollTitleBar.elementDisplayStyle = self.topTitleStyle;
        _scrollTitleBar.delegate = self;
        //        _scrollTitleBar.showRightBorder = YES;
        //        _scrollTitleBar.showLeftBorder = NO;//设置左侧阴影不显示
        [_scrollTitleBar setBackgroundColor:[UIColor whiteColor]];
        
        
    }
    return _scrollTitleBar;
}

-(UIViewController*)getViewControllerWithIndex:(NSUInteger)aIndex
{
    if (aIndex<_childViewControllerDic.count)
    {
        return _childViewControllerDic[@(aIndex)];
    }
    else
    {
        return nil;
    }
}
- (void)reloadData
{
    self.isReloading = YES;
    UIViewController *currentShowViewConntroller = [self viewControllerAtIndex:_currentPage];
    
    _pageCount = 0;
    _currentPage = _selectedIndex;
    _selectedIndex = _currentPage;
    _lastSelectIndex = -1;
    
    if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(numberOfTitleInScrollNavigationViewController:)]) {
        _pageCount = [_scrollNavigationDataSource numberOfTitleInScrollNavigationViewController:self];
    }
    
    [self.view addSubview:self.scrollTitleBar];
    
    if (_scrollContentView) {
        _scrollContentView.delegate = nil;
        _scrollContentView = nil;
    }
    
    _scrollContentView = [[MTScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollTitleBar.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.scrollTitleBar.bounds))];
    [_scrollContentView setBackgroundColor:[UIColor clearColor]];
    [_scrollContentView setShowsHorizontalScrollIndicator:NO];
    [_scrollContentView setShowsVerticalScrollIndicator:NO];
    [_scrollContentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    //    if (statusHeight>=40) {
    //        [_scrollContentView setContentSize:CGSizeMake(size.width * _pageCount, size.height-20)];
    //    }
    //    else
    //    {
    [_scrollContentView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame) * _pageCount, CGRectGetHeight(self.view.frame))];
    //    }
    [_scrollContentView setBounces:NO];
    [_scrollContentView setCanCancelContentTouches:NO];
    [_scrollContentView setScrollsToTop:NO];
    [_scrollContentView setDelegate:self];
    [_scrollContentView setPagingEnabled:YES];
    [_scrollContentView setDirectionalLockEnabled:YES];
    [_scrollContentView setAutoresizesSubviews:YES];
    [_scrollContentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_scrollContentView];
    
    //创建多个子视图用于存放子视图控制器的视图
    for (int i = 0; i < _pageCount; i++) {
        
        UIView *scrollSubView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollContentView.frame) * i, 0, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))];
        [scrollSubView setClipsToBounds:YES];
        [scrollSubView setBackgroundColor:[UIColor clearColor]];
        [scrollSubView setTag:AHSNVC_ScrollSubviews_tag + i];
        [scrollSubView setAutoresizesSubviews:YES];
        [scrollSubView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_scrollContentView addSubview:scrollSubView];
    }
    
    
    if(currentShowViewConntroller)
    {
        [currentShowViewConntroller beginAppearanceTransition:NO animated:NO];
    }
    //移除掉所有的控制器视图
    [_childViewControllerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         UIViewController *vc = (UIViewController*)obj;
         if(vc.isViewLoaded)
         {
             [vc.view removeFromSuperview];
         }
         [vc willMoveToParentViewController:nil];
         [vc removeFromParentViewController];
     }];
    
    if(currentShowViewConntroller)
    {
        [currentShowViewConntroller endAppearanceTransition];
    }
    [_childViewControllerDic removeAllObjects];
    [self endPaging];//显示当前选中视图
    
    self.isReloading = NO;
}
- (void)endPaging
{
    _selectedIndex = _currentPage;
    
    
    //记录下上一次的页码，如果上一次的页码与这次的相同，就不做任何操作
    if (_lastSelectIndex == _currentPage) {
        
        self.pageChangedByClick = NO;
        self.currentShowIndex = _currentPage;
        self.currentWillShowIndex = MAXFLOAT;
        
        self.currentViewController = nil;
        self.willShowViewController = nil;
        
        return;
    }
    
    
    
    //这儿记录有问题，此处记录后面委托拿到后就是当前index而不是last yangrui
    //_lastPage = _currentPage;
    
    //尝试从字典中读取
    UIViewController *subViewController = _childViewControllerDic[@(_currentPage)];
    
    UIViewController *lastViewController = _childViewControllerDic[@(_lastSelectIndex)];
    
    if (subViewController == nil)
    {
        //尝试获取一个子视图控制器
        if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(scrollNavigationViewController:childViewControllerForIndex:)])
        {
            subViewController = [_scrollNavigationDataSource scrollNavigationViewController:self childViewControllerForIndex:_currentPage];
            _childViewControllerDic[@(_currentPage)] = subViewController;
            
            
        }
    }
    
    //向子控制器回调即将消失的回调
    if (lastViewController && [lastViewController respondsToSelector:@selector(childViewWillDisAppearInScrollNavigtionViewController:)]) {
        
        [(id)lastViewController childViewWillDisAppearInScrollNavigtionViewController:self];
    }
    
    
    //如果还未添加到占位视图中，则立即添加
    if (subViewController && [_scrollContentView viewWithTag:AHSNVC_ScrollSubviews_tag + _currentPage].subviews.count == 0){
        
        [subViewController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))];
        [self addChildViewController:subViewController];
        [subViewController didMoveToParentViewController:self];
        
        [[_scrollContentView viewWithTag:AHSNVC_ScrollSubviews_tag + _currentPage] addSubview:subViewController.view];
        
    }
    
    //向子控制器回调即将显示的回调
    if (subViewController && [subViewController respondsToSelector:@selector(childViewWillAppearInScrollNavigtionViewController:clientViewSize:contentInset:)]) {
        
        [(id)subViewController childViewWillAppearInScrollNavigtionViewController:self clientViewSize:CGSizeMake(0,0) contentInset:UIEdgeInsetsZero];
    }
    
    
    
    //回调选中项改变的回调
    if (_scrollNavigationDelegate && [_scrollNavigationDelegate respondsToSelector:@selector(scrollNavigationViewController:hasChangedSelected:)]) {
        [_scrollNavigationDelegate scrollNavigationViewController:self hasChangedSelected:_currentPage];
    }
    
    if (self.isFinishViewDidLoad)
    {
        {
            [lastViewController beginAppearanceTransition:NO animated:YES];
            [subViewController beginAppearanceTransition:YES animated:YES];
            
            [lastViewController endAppearanceTransition];
            [subViewController endAppearanceTransition];
            
            
        }
    }
    //移动到执行代理函数完成后记录
    _lastSelectIndex = _currentPage;
    
    self.pageChangedByClick = NO;
    self.currentShowIndex = _currentPage;
    self.currentWillShowIndex = MAXFLOAT;
    
    self.currentViewController = nil;
    self.willShowViewController = nil;
}

-(BOOL)canScrollWithGesture:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.scrollNavigationDelegate &&
        [self.scrollNavigationDelegate respondsToSelector:@selector(canScrollWithGesture:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.scrollNavigationDelegate canScrollWithGesture:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Remember page index before rotation
    _pageIndexBeforeRotation = _selectedIndex;
    
    
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Perform layout
    _selectedIndex = _pageIndexBeforeRotation;
    _currentPage = _selectedIndex;
    
}

#pragma mark - 转屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.pageChangedByClick) {
            return;
        }
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat scale = (fabs(scrollView.contentOffset.x - _beginOffserX))/CGRectGetWidth(scrollView.frame);
        
        if (scrollView.contentOffset.x > _beginOffserX) {
            [self.scrollTitleBar scrollingToNextElement:YES scale:scale];
        }else{
            [self.scrollTitleBar scrollingToNextElement:NO scale:scale];
        }
    }
}
#pragma mark- UIScrollViewDelegete
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if ((fabs(scrollView.contentOffset.x) > scrollView.contentSize.width) || (fabs(scrollView.contentOffset.y) > scrollView.contentSize.height)) {
        return;
    }
    
    if (self.scrollNavigationDelegate && [self.scrollNavigationDelegate respondsToSelector:@selector(scrollNavigationViewControllerDidScroll:)]) {
        [self.scrollNavigationDelegate scrollNavigationViewControllerDidScroll:scrollView];
    }
    
    if (self.pageChangedByClick)
    {
        return;
    }
    if (!scrollView.dragging)
    {
        return;
    }
    
    if (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width ) {
        return;
    }
    
    if (scrollView.contentOffset.x > self.currentShowIndex * pageWidth)
    {
        NSUInteger jumpPageCount = ceil((scrollView.contentOffset.x - self.currentShowIndex * pageWidth)/pageWidth);
        
        if (self.currentWillShowIndex != self.currentShowIndex + jumpPageCount)
        {
            self.currentWillShowIndex = self.currentShowIndex + jumpPageCount;
            
            
            self.willShowViewController = [self viewControllerAtIndex:self.currentWillShowIndex];
            //如果还未添加到占位视图中，则立即添加
            if ( [_scrollContentView viewWithTag:AHSNVC_ScrollSubviews_tag + self.currentWillShowIndex].subviews.count == 0){
                
                [self.willShowViewController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))];
                [self addChildViewController:self.willShowViewController];
                [self.willShowViewController didMoveToParentViewController:self];
                [[_scrollContentView viewWithTag:AHSNVC_ScrollSubviews_tag + self.currentWillShowIndex] addSubview:self.willShowViewController.view];
            }
            
            self.currentViewController = [self viewControllerAtIndex:self.currentWillShowIndex-1];
        }
    }
    else  if (scrollView.contentOffset.x < self.currentShowIndex * pageWidth)
    {
        
        NSUInteger jumpPageCount = ceil((self.currentShowIndex * pageWidth - scrollView.contentOffset.x)/pageWidth);
        
        if (self.currentWillShowIndex != self.currentShowIndex - jumpPageCount)
        {
            
            self.currentWillShowIndex = self.currentShowIndex - jumpPageCount;
            
            
            self.willShowViewController = [self viewControllerAtIndex:self.currentWillShowIndex];
            //如果还未添加到占位视图中，则立即添加
            if ( [_scrollContentView viewWithTag:AHSNVC_ScrollSubviews_tag + self.currentWillShowIndex].subviews.count == 0){
                
                [self.willShowViewController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))];
                [self addChildViewController:self.willShowViewController];
                [self.willShowViewController didMoveToParentViewController:self];
                [[_scrollContentView viewWithTag:AHSNVC_ScrollSubviews_tag + self.currentWillShowIndex] addSubview:self.willShowViewController.view];
            }
            
            self.currentViewController = [self viewControllerAtIndex:self.currentWillShowIndex+1];
        }
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _beginOffserX = scrollView.contentOffset.x;
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
    [self.scrollTitleBar selecteIndex:_currentPage];
    
    self.pageChangedByClick = NO;
}
#pragma  mark - 电池条支持

- (UIViewController *)childViewControllerForStatusBarStyle{
    return [_scrollNavigationDataSource scrollNavigationViewController:self childViewControllerForIndex:_currentPage];
}
- (UIViewController *)childViewControllerForStatusBarHidden{
    return [_scrollNavigationDataSource scrollNavigationViewController:self childViewControllerForIndex:_currentPage];
}


#pragma  mark - 子控制器生命周期控制开关

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

#pragma mark - mtscrolltitlebar
- (NSInteger)numberOfTitleInScrollTitleBar:(MTScrollTitleBar *)scrollTitleBar
{
    if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(numberOfTitleInScrollNavigationViewController:)]) {
        return [_scrollNavigationDataSource numberOfTitleInScrollNavigationViewController:self];
    }
    return 0;
}


- (NSString*)scrollTitleBar:(MTScrollTitleBar*)scrollTitleBar titleForIndex:(NSInteger)index
{
    if (_scrollNavigationDataSource && [_scrollNavigationDataSource respondsToSelector:@selector(scrollNavigationViewController:titleForIndex:)]) {
        return [_scrollNavigationDataSource scrollNavigationViewController:self titleForIndex:index];
    }
    return @"";
}

- (BOOL)enableAutoAdjustWidth:(MTScrollTitleBar *)scrollTitleBar
{
    if ([self.scrollNavigationDataSource respondsToSelector:@selector(scrollTitleBarEnableAutoAdjust:)]) {
        return [self.scrollNavigationDataSource scrollTitleBarEnableAutoAdjust:self];
    }
    return NO;
}

- (void)clickItem:(MTScrollTitleBar *)scrollTitleBar atIndex:(NSInteger)aIndex
{
    if (self.scrollNavigationDelegate && [self.scrollNavigationDelegate respondsToSelector:@selector(scrollNavigationViewControllerWillScrollFromIndex:toIndex:scrollNavigationViewController:)]) {
        [self.scrollNavigationDelegate scrollNavigationViewControllerWillScrollFromIndex:_currentPage toIndex:aIndex scrollNavigationViewController:self];
    }
    
    _currentPage = aIndex;
    _selectedIndex = aIndex;
    
    self.pageChangedByClick = YES;
    [_scrollContentView setContentOffset:CGPointMake(CGRectGetWidth(_scrollContentView.frame) * aIndex, 0) animated:YES];
}

@end

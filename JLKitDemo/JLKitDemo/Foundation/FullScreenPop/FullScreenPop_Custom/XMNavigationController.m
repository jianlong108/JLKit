//
//  XMNavigationController.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "XMNavigationController.h"
#import "UIViewController+XMNavigationController.h"
#import "XMNavigationController+Stack.h"
#import "XMNavigationController+Animation.h"
#import "XMNavigationController+PanGesture.h"

@interface UIView(XMNavigationController)

- (void)resignFirstResponderInSelf;

@end

@implementation UIView(XMNavigationController)

- (void)resignFirstResponderInSelf
{
    [self resignFirstResponder];
    
    for (UIView *subView in [self subviews])
    {
        [subView resignFirstResponderInSelf];
    }
    
}

@end


@interface UIViewController ()

@property (nonatomic,readonly,strong) NSString *identifier;

@property(nullable, nonatomic,strong) XMNavigationController *myNavigationController;

@end


@interface XMNavigationController ()<
    UIGestureRecognizerDelegate
>
{
    NSMutableArray *_viewControllers;
}

@property (nonatomic,strong) NSHashTable *hashTable;

@property (nonatomic,strong) UIView *containterView;

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) UIView *animationView;

@property (nonatomic,assign) CGPoint startTouch;

@property (nonatomic,assign) BOOL shouldBegin;

@property (nonatomic,assign) XMPanMoveDirection panMoveDirection;

@property (nonatomic, readwrite, strong) UIPanGestureRecognizer *panGestureRecognizer;


@property (nonatomic, readwrite, strong) UIViewController *rootViewController;

@property (nonatomic, assign, readwrite,getter = isLayouting) BOOL layouting;

@property (nonatomic, assign, readwrite,getter = isPushing) BOOL pushing;


@property (nonatomic, strong,readwrite) NSMutableArray *willPopControllerIdentifierArray;

@property (atomic,strong)NSMutableArray *observers;

//对点击statusbar 返回顶部的支持
@property(nonatomic,strong) NSMutableDictionary *scrollViewInViewControllerDictionary;
@property(nonatomic,strong) NSMutableDictionary *scrollViewAndHashCodeDictionary;

@end

#if USE_XMNavigationController == 0

@implementation XMNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationBar.hidden = YES;
}
//以下两个方法为了解决  当UITabBarController中的每一个tab为XMNavigationController
//当切换tab时AHNavigationController中的控制器 生命周期调用错误问题
- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated
{
    [self.topViewController beginAppearanceTransition:isAppearing animated:animated];
}

- (void)endAppearanceTransition
{
    [self.topViewController endAppearanceTransition];
}


- (void)dealloc
{
    
}

#pragma mark - 电池条支持

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

#pragma mark - 旋转方法
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //解决ios8第一次调用时且[self topViewController]不存在的情况下，返回[[self topViewController] supportedInterfaceOrientations]会导致以后的旋转屏错误
    if (!self.topViewController)
    {
        return [super supportedInterfaceOrientations];
    }
    return [[self topViewController] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    if (!self.topViewController)
    {
        return [super shouldAutorotate];
    }
    
    BOOL result = [[self topViewController] shouldAutorotate] && !self.isPanning && !self.isPushing;
    if (result)
    {
        [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *viewController = (UIViewController *)obj;
            if (viewController.isViewLoaded)
            {
                viewController.view.hidden = YES;
            }
        }];
        
        self.topViewController.view.hidden = NO;
        //当点击pop返回时,会触发屏幕旋转这是topViewController 与最后一个控制器不一致
        [[[self.viewControllers lastObject] view] setHidden:NO];
    }
    else
    {
        [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *viewController = (UIViewController *)obj;
            if (viewController.isViewLoaded)
            {
                viewController.view.hidden = NO;
            }
        }];
        
    }
    return result;
    
}

#pragma mark - 压栈控制器方法 -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    [super pushViewController:viewController animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animatiomType:(AHNavigationViewAnimationType)animationType
{
    [super pushViewController:viewController animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animatiomType:(AHNavigationViewAnimationType)animationType animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    
    [super pushViewController:viewController animated:YES];
    
}


#pragma mark - 出栈控制器方法

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
    
}



- (UIViewController *)popViewControllerAnimated:(BOOL)animated animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    
    return [super popViewControllerAnimated:YES];
    
}


- (UIViewController *)popViewControllerWithAnimationType:(AHNavigationViewAnimationType)animationType
{
    
    return [super popViewControllerAnimated:YES];
    
}
//
- (UIViewController *)popViewControllerWithAnimationType:(AHNavigationViewAnimationType)animationType animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    return [super popViewControllerAnimated:YES];
}
#pragma mark -
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return  [super popToRootViewControllerAnimated:animated];
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    return [super popToRootViewControllerAnimated:YES];
    
}

- (NSArray *)popToRootViewControllerWithAnimationType:(AHNavigationViewAnimationType)animationType
{
    return [super popToRootViewControllerAnimated:YES];
}

- (NSArray *)popToRootViewControllerWithAnimationType:(AHNavigationViewAnimationType)animationType animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    
    return [super popToRootViewControllerAnimated:YES];
    return [self popToViewController:self.rootViewController withAnimationType:animationType animationCompletion:completionBlock];
}

#pragma mark -

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return  [super popToViewController:viewController animated:animated];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    return [super popToViewController:viewController animated:YES];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController withAnimationType:(AHNavigationViewAnimationType)animationType
{
    return [super popToViewController:viewController animated:YES];
}

- (NSArray *)popToViewController:(UIViewController *)viewController withAnimationType:(AHNavigationViewAnimationType)animationType animationCompletion:(AHNavigationAnimationCompletionBlock)completionBlock
{
    return  [super popToViewController:viewController animated:YES];
}

@end

#else

@implementation XMNavigationController

#pragma mark - get 方法
- (UIView *)maskView
{
    if (!_maskView)
    {
        _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _maskView.alpha = 0.0;
        _maskView.tag = 400;
        
    }
    
    return _maskView;
}

- (UIView *)animationView
{
    if (!_animationView)
    {
        _animationView = [[UIView alloc]initWithFrame:self.view.bounds];
        _animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        _animationView.backgroundColor = [UIColor blackColor];
        _animationView.tag = 404;
    }
    
    return _animationView;
    
}

- (UIView *)containterView
{
    if (!_containterView)
    {
        _containterView = [[UIView alloc] init];
        _containterView.frame = self.view.bounds;
        _containterView.backgroundColor = [UIColor blackColor];
        
        _containterView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _containterView.tag = 300;
    }
    
    return _containterView;
}

- (NSMutableArray *)viewControllers
{
    if (!_viewControllers)
    {
        _viewControllers = [NSMutableArray array];
    }
    
    return _viewControllers;
}


- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    if (viewControllers != _viewControllers)
    {
        NSArray *temArray = [NSArray arrayWithArray:_viewControllers];
        [temArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![viewControllers containsObject:obj])
            {
                [self removeController:obj];
            }
        }];
        
        _viewControllers = [NSMutableArray array];
        
        [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *viewController = obj;
            viewController.myNavigationController = self;
            [self addController:obj];
        }];
        _rootViewController = _viewControllers.firstObject;
        
        [self resetSubViews];
    }
}


- (NSMutableArray *)willPopControllerIdentifierArray
{
    if (!_willPopControllerIdentifierArray)
    {
        _willPopControllerIdentifierArray = [NSMutableArray array];
    }
    
    return _willPopControllerIdentifierArray;
}


- (UIViewController *)visibleViewController
{
    return [self topViewController];
}


- (NSMutableDictionary *)scrollViewInViewControllerDictionary
{
    if (!_scrollViewInViewControllerDictionary)
    {
        _scrollViewInViewControllerDictionary = [NSMutableDictionary dictionary];
    }
    return _scrollViewInViewControllerDictionary;
}

- (NSMutableDictionary *)scrollViewAndHashCodeDictionary
{
    if (!_scrollViewAndHashCodeDictionary)
    {
        _scrollViewAndHashCodeDictionary = [NSMutableDictionary dictionary];
    }
    return _scrollViewAndHashCodeDictionary;
}

#pragma mark - 初始化方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _panValid = YES;
        _layouting = NO;
        _hashTable = [NSHashTable weakObjectsHashTable];
        
        _animationDuration = 0.25;
        _observers = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        rootViewController.myNavigationController = self;
        [self addController:rootViewController];
        _rootViewController = rootViewController;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(paningGestureReceive:)];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    [_panGestureRecognizer setDelegate:self];
    
    _panGestureRecognizer.delaysTouchesEnded = NO;
    [self.view addGestureRecognizer:_panGestureRecognizer];
    
    [self.view addSubview:self.containterView];
    
    [self resetSubViews];
}

- (void)resetSubViews
{
    
    //全部移除会影响viewControllers中Controller的View的生命周期 所以使用方法 checkSubViews
    [self checkSubViews];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = (UIViewController *)obj;
        if (viewController.isViewLoaded)
        {
            viewController.view.frame = self.view.bounds;
            [self.containterView insertSubview:viewController.view atIndex:idx];
        }
        
    }];
    self.topViewController.view.hidden = NO;
    self.topViewController.view.frame = self.view.bounds;
    [self.containterView addSubview:self.topViewController.view];
    [self.containterView insertSubview:self.animationView atIndex:0];
    
    [self.containterView insertSubview:self.maskView atIndex:1];
    
}

/**
 获取视图上的所有view，检查这个view是否是ViewController是中的某个Controller的View
 如果不是则移除
 */
- (void)checkSubViews
{
    NSArray *subViews = [self.containterView subviews];
    NSMutableArray *viewArray = [NSMutableArray array];
    
    //获取所有Controller的View到viewArray中
    [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = (UIViewController *)obj;
        if (viewController.isViewLoaded)
        {
            [viewArray addObject:viewController.view];
        }
    }];
    
    //检查每一个view是否是ViewController是中的某个Controller的View，如果不是则移除
    [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        if(![viewArray containsObject:view])
        {
            [view removeFromSuperview];
        }
    }];
    
}


#pragma mark - 压栈控制器方法 -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [self pushViewController:viewController animated:animated animationCompletion:nil];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    if (animated)
    {
        
        [self pushViewController:viewController animatiomType:XMNavigationViewAnimationTypeRightToLeft animationCompletion:completionBlock];
    }
    else
    {
        [self pushViewController:viewController animatiomType:XMNavigationViewAnimationTypeNone animationCompletion:completionBlock];
    }
}

- (void)pushViewController:(UIViewController *)viewController animatiomType:(XMNavigationViewAnimationType)animationType
{
    [self pushViewController:viewController animatiomType:animationType animationCompletion:nil];
}

- (void)pushViewController:(UIViewController *)viewController animatiomType:(XMNavigationViewAnimationType)animationType animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if (!viewController)
    {
        return;
    }
    
    self.pushing = YES;
    //willPopControllerIdentifierArray 中删除已经pop后的 identifier
    [self.willPopControllerIdentifierArray removeAllObjects];
    
    
    viewController.myNavigationController = self;
    viewController.pushAnimationType = animationType;
    
    UIViewController *fromeViewController = [self topViewController];
    
    
    //在真正执行push前，回调给顶层控制器方法
    if ([fromeViewController respondsToSelector:@selector(navigationController:willPush:)])
    {
        [(id<UIViewControllerInXMNavigationProtocol>)fromeViewController  navigationController:self willPush:viewController];
    }
    
    //向所有监听对象发送即将压栈事件
    [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @try {
            if ([obj respondsToSelector:@selector(navigationController:topViewController:willShowViewController:)]) {
                [obj navigationController:self topViewController:fromeViewController willShowViewController:viewController];
            }
        } @catch (NSException *exception) {
            
        }
    }];
    
    fromeViewController = [self topViewController];
    
    
    [fromeViewController resignFirstResponder];
    [fromeViewController.view resignFirstResponderInSelf];
    
    [fromeViewController beginAppearanceTransition:NO animated:YES];
    [viewController beginAppearanceTransition:YES animated:YES];
    
    [self addController:viewController];
    [self resetSubViews];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    if (animationType == XMNavigationViewAnimationTypeNone)
    {
        viewController.view.frame = self.view.bounds;
        [self.containterView insertSubview:self.maskView belowSubview:viewController.view];
        
        [fromeViewController.view removeFromSuperview];
        
        [fromeViewController endAppearanceTransition];
        [viewController endAppearanceTransition];
        
        [self handleScrollViewAndFlagInViewController:fromeViewController];
        
        self.pushing = NO;
        
        //向所有监听对象发送压栈完成事件
        [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            @try {
                if ([obj respondsToSelector:@selector(navigationController:didShowViewController:)]) {
                    [obj navigationController:self didShowViewController:viewController];
                }
            } @catch (NSException *exception) {
                
            }
        }];
        if (completionBlock)
        {
            completionBlock();
        }
    }
    else
    {
        [self pushAnimationType:animationType
             fromViewController:fromeViewController
               toViewController:viewController
                   onCompletion:^{
                       
                       [fromeViewController endAppearanceTransition];
                       [viewController endAppearanceTransition];
                       
                       [self handleScrollViewAndFlagInViewController:fromeViewController];
                       self.pushing = NO;
                       
                       //向所有监听对象发送压栈完成事件
                       [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                           
                           @try {
                               if ([obj respondsToSelector:@selector(navigationController:didShowViewController:)]) {
                                   [obj navigationController:self didShowViewController:viewController];
                               }
                           } @catch (NSException *exception) {
                               
                           }
                       }];
                       
                       if (completionBlock)
                       {
                           completionBlock();
                       }
                       
                   }];
    }
    
}


#pragma mark - 出栈控制器方法

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [self popViewControllerAnimated:animated animationCompletion:nil];
}



- (UIViewController *)popViewControllerAnimated:(BOOL)animated animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    
    UIViewController *viewController = [self topViewController];
    XMNavigationViewAnimationType popAnimationType = XMNavigationViewAnimationTypeNone;
    
    if (animated)
    {
        if (viewController.pushAnimationType == XMNavigationViewAnimationTypeNone)
        {
            popAnimationType = XMNavigationViewAnimationTypeLeftToRight;
        }
        else
        {
            popAnimationType = -viewController.pushAnimationType;
        }
    }
    
    return [self popViewControllerWithAnimationType:popAnimationType
                                animationCompletion:completionBlock];
}


- (UIViewController *)popViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType
{
    
    return [self popViewControllerWithAnimationType:animationType animationCompletion:nil];
    
}

- (UIViewController *)popViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    UIViewController *toViewController = [self belowViewController];
    NSArray *result = [self popToViewController:toViewController withAnimationType:animationType animationCompletion:completionBlock];
    
    return [result lastObject];
    
}
#pragma mark -
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return  [self popToRootViewControllerAnimated:animated animationCompletion:nil];
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    return [self popToRootViewControllerWithAnimationType:animated ? XMNavigationViewAnimationTypeLeftToRight: XMNavigationViewAnimationTypeNone
                                      animationCompletion:completionBlock];
}

- (NSArray *)popToRootViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType
{
    return [self popToRootViewControllerWithAnimationType:animationType animationCompletion:nil];
}


- (NSArray *)popToRootViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    return [self popToViewController:self.rootViewController withAnimationType:animationType animationCompletion:completionBlock];
}

#pragma mark -

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [self popToViewController:viewController animated:animated animationCompletion:nil];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    if (animated)
    {
        return [self popToViewController:viewController withAnimationType:XMNavigationViewAnimationTypeLeftToRight animationCompletion:completionBlock];
    }
    else
    {
        return [self popToViewController:viewController withAnimationType:XMNavigationViewAnimationTypeNone animationCompletion:completionBlock];
    }}



- (NSArray *)popToViewController:(UIViewController *)viewController withAnimationType:(XMNavigationViewAnimationType)animationType
{
    return [self popToViewController:viewController
                   withAnimationType:animationType
                 animationCompletion:nil];
}




- (NSArray *)popToViewController:(UIViewController *)viewController withAnimationType:(XMNavigationViewAnimationType)animationType animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    if ([self.viewControllers[0] isEqual:viewController]) {
        viewController.hidesBottomBarWhenPushed = NO;
    }else{
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    UIViewController *fromViewController = [self topViewController];
    UIViewController *toViewController = viewController;
    
    if (!toViewController ||
        (viewController.myNavigationController != self) ||
        viewController == fromViewController)
    {
        return nil;
    }
    
    
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = (UIViewController *)obj;
        if (viewController.isViewLoaded)
        {
            viewController.view.hidden = NO;
        }
    }];
    
    
    NSArray *result = [self viewControllersAfterViewController:viewController];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *tempViewController = obj;
        [self.willPopControllerIdentifierArray addObject:tempViewController.identifier];
        
    }];
    
    //下个版本上
    UIInterfaceOrientationMask mask= [toViewController supportedInterfaceOrientations];
    if(mask==UIInterfaceOrientationMaskPortrait)
    {
        //设置屏幕的转向为竖屏
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    else if (mask==UIInterfaceOrientationMaskLandscapeLeft)
    {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    else if (mask==UIInterfaceOrientationMaskLandscapeRight)
    {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
        
    }
    else if (mask==UIInterfaceOrientationMaskLandscape)
    {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
        //刷新
        [UIViewController attemptRotationToDeviceOrientation];
    }
    
//    [self adjustTabBar:toViewController];
    
    
    [fromViewController resignFirstResponder];
    [fromViewController.view resignFirstResponderInSelf];
    
    [fromViewController beginAppearanceTransition:NO animated:YES];
    [toViewController beginAppearanceTransition:YES animated:YES];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.containterView insertSubview:toViewController.view belowSubview:fromViewController.view];
    if (animationType != XMNavigationViewAnimationTypeNone)
    {
        
        [self popAnimationType:animationType
            fromViewController:fromViewController
              toViewController:toViewController
                  onCompletion:^
         {
             [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop)
              {
                  UIViewController *controller = obj;
                  [weakSelf removeController:controller];
              }];
             
             [fromViewController endAppearanceTransition];
             [toViewController endAppearanceTransition];
             
//             [weakSelf resetTabBar];
             
             [weakSelf.willPopControllerIdentifierArray removeAllObjects];
             
             //处理点击 status
             [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop)
              {
                  UIViewController *viewController = obj;
                  [weakSelf recoveryScrollViewAndFlagInViewController:viewController andRemoveItem:YES];
              }];
             [weakSelf recoveryScrollViewAndFlagInViewController:toViewController];
             
             if (completionBlock)
             {
                 completionBlock();
             }
         }];
        
        
    }
    else
    {
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *controller = obj;
            [self removeController:controller];
        }];
        
        [self.maskView.superview insertSubview:self.maskView atIndex:0];
        
        [fromViewController resignFirstResponder];
        
        [fromViewController endAppearanceTransition];
        [toViewController endAppearanceTransition];
//        [self resetTabBar];
        
        [self.willPopControllerIdentifierArray removeAllObjects];
        
        //处理点击 status
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *viewController = obj;
            [self recoveryScrollViewAndFlagInViewController:viewController];
            [self.scrollViewInViewControllerDictionary removeObjectForKey:viewController.identifier];
        }];
        [self recoveryScrollViewAndFlagInViewController:toViewController];
        
        if (completionBlock)
        {
            completionBlock();
        }
    }
    
    
    
    return result;
}

#pragma - 处理ios10 以下 点击statusBar scrollToTop问题
- (void)handleScrollViewAndFlagInViewController:(UIViewController *)viewController
{
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0))
    {
        return;
    }
    NSMutableDictionary *scrollViewAndEnableFlagDic = [NSMutableDictionary dictionary];
    NSArray *scrollViewArray = [self scrollViewsInView:viewController.view];
    
    for (UIScrollView *scrollView in scrollViewArray)
    {
        
        NSString *key = [NSString stringWithFormat:@"%ld",[scrollView hash]];
        [scrollViewAndEnableFlagDic setObject:[NSNumber numberWithBool:scrollView.scrollsToTop]
                                       forKey:key];
        
        [self.scrollViewAndHashCodeDictionary setObject:scrollView forKey:key];
        
        scrollView.scrollsToTop = NO;
    }
    
    if ([[scrollViewAndEnableFlagDic allKeys] count] >0)
    {
        [self.scrollViewInViewControllerDictionary setObject:scrollViewAndEnableFlagDic
                                                      forKey:viewController.identifier];
    }
}



- (void)recoveryScrollViewAndFlagInViewController:(UIViewController *)viewController
{
    [self recoveryScrollViewAndFlagInViewController:viewController andRemoveItem:NO];
}

- (void)recoveryScrollViewAndFlagInViewController:(UIViewController *)viewController andRemoveItem:(BOOL)remove
{
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0))
    {
        return;
    }
    
    NSMutableDictionary *scrollViewAndEnableFlagDic = [self.scrollViewInViewControllerDictionary objectForKey:viewController.identifier];
    NSArray *allKeys = [scrollViewAndEnableFlagDic allKeys];
    for (NSString *key in allKeys)
    {
        UIScrollView *scrollView = [self.scrollViewAndHashCodeDictionary objectForKey:key];
        scrollView.scrollsToTop = [[scrollViewAndEnableFlagDic objectForKey:key] boolValue];
        
        if (remove)
        {
            [self.scrollViewAndHashCodeDictionary removeObjectForKey:[NSString stringWithFormat:@"%ld",[scrollView hash]]];
        }
    }
    
    if (remove)
    {
        [self.scrollViewInViewControllerDictionary removeObjectForKey:viewController.identifier];
    }
}


- (NSArray *)scrollViewsInView:(UIView *)view
{
    NSMutableArray *result = [NSMutableArray array];
    NSArray *subViews = view.subviews;
    
    if (!subViews || subViews.count == 0)
    {
        return nil;
    }
    
    for (UIView *subView in subViews)
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            [result addObject:subView];
        }
        
        NSArray *tem = [self scrollViewsInView:subView];
        if (tem)
        {
            [result addObjectsFromArray:tem];
        }
    }
    
    return result;
}


- (void)addEventObserver:(id<UIViewControllerInXMNavigationMonitorEventProtocol>)observer{
    
    [self.observers addObject:observer];
}

- (void)removeEventObserver:(id<UIViewControllerInXMNavigationMonitorEventProtocol>)observer{
    
    [self.observers removeObject:observer];
}


@end

#endif

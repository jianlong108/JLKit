//
//  NavigationTranstionEngine.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/12.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "NavigationTranstionEngine.h"
#import "UIViewController+FullScreenPop.h"
#import "UIPanGestureRecognizer+PanDirection.h"
#import "UIViewController+NavigationBar.h"



static NSString *const selecterPrefix = @"_";
static NSString *const selecterSuffix = @"InteractiveTransition";

#define SuppressPerformSelectorLeakWarning(Stuff) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
        _Pragma("clang diagnostic pop") \
    } while (0)

@interface FullScreenPopAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface NavigationTranstionEngine()<
    UINavigationControllerDelegate,
    UIGestureRecognizerDelegate
>

@property (nonatomic, strong) id targetTransition;

@property (nonatomic, weak) UINavigationController *innerNavigationController;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@property (nonatomic, weak) UIViewController *disAppearingViewController;

@property (nonatomic, assign)  BOOL disAppearingViewController_HideBottomBar;

@property (nonatomic, assign) XMPanMoveDirection  panMoveDirection;

@property (nonatomic,strong) NSHashTable *gestureshashTable;

@end

@implementation NavigationTranstionEngine

- (void)dealloc
{
    NSLog(@"wjl log %@->NavigationTranstionEngine(%@) dealloc",self.innerNavigationController,self);
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        _gestureshashTable = [[NSHashTable alloc]init];
        _innerNavigationController = navigationController;
        [self addGesture];
    }
    return self;
}

- (void)addGesture
{
    UIGestureRecognizer *gesture = self.innerNavigationController.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    id target = gesture.delegate;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    
    self.targetTransition = target;
    //方案一
    [popRecognizer addTarget:self action:@selector(handleNavigationTransition:)];
    [popRecognizer addTarget:self.targetTransition action:@selector(handleNavigationTransition:)];
    //方案二 需要自己实现转场动画，最主要需要处理navigationbar 和 tabbar 的过度动画
//    [popRecognizer addTarget:self action:@selector(handleControllerPop:)];
    
}

#pragma mark - gestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer
{
    //当向左滑动时，禁止滑动返回手势工作
    if ([recognizer velocityInView:recognizer.view].x < 0) {
        return NO;
    }
    if (self.innerNavigationController.viewControllers.count <= 1) {
        return NO;
    }
    if ([[self.innerNavigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if ([self.innerNavigationController.topViewController supportFullScreenPop]) {
        return [self.innerNavigationController.topViewController navigationBackCanBeginWithGestureRecognizer:recognizer];
    }else{
        return NO;
    }
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [self.innerNavigationController.topViewController navigationGestureRecognizer:gestureRecognizer shouldRequireFailureOfGestureRecognizer:otherGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([self.innerNavigationController.topViewController respondsToSelector:@selector(backRecognizerResolvedBySystem)])
    {
        result =  [self.innerNavigationController.topViewController backRecognizerResolvedBySystem];
    }
    if (result) {
        [self.gestureshashTable addObject:otherGestureRecognizer];
    }
    return result;
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [self.gestureshashTable removeAllObjects];
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}



- (void)handleNavigationTransition:(UIPanGestureRecognizer *)recognizer
{

    CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
   
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.panMoveDirection = kXMPanMoveDirectionNone;
        
        _disAppearingViewController = [self.innerNavigationController topViewController];
        _disAppearingViewController_HideBottomBar = _disAppearingViewController.hidesBottomBarWhenPushed;
//        [self startNavigationTransiton];
        
        NSLog(@"%@ %@",NSStringFromSelector(_cmd),_disAppearingViewController);
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if (self.panMoveDirection == kXMPanMoveDirectionNone) {
            self.panMoveDirection = [recognizer determinePanDirectionIfNeeded:[recognizer translationInView:recognizer.view]];
        }
        if (self.panMoveDirection != kXMPanMoveDirectionNone)
        {
            //默认支持向右滑动返回
            XMPanMoveDirection supportDirection = kXMPanMoveDirectionRight;
            
            //如果controller 不支持此方向滑动返回，则取消本次手势
            if ((supportDirection & self.panMoveDirection) != self.panMoveDirection)
            {
                recognizer.enabled = NO;
                recognizer.enabled = YES;
                
//                [self resetNavigationTransiton];
                return;
            } else {
                for (UIGestureRecognizer *gesture in self.gestureshashTable) {
                    gesture.enabled = NO;
                    gesture.enabled = YES;
                }
                [self.gestureshashTable removeAllObjects];
            }
            
//            [self updateNavigationTransiton:progress];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        /**
         *  手势结束时如果进度大于一半，那么就完成pop操作，否则重新来过。
         */
        if (progress >= 0.3) {
            [self successCompleteNavigationTransiton];
        }
        else {
//            [self resetNavigationTransiton];
            
            _disAppearingViewController.hidesBottomBarWhenPushed = _disAppearingViewController_HideBottomBar;
            _disAppearingViewController.needUpdateNavigationBarWhenFullScreenPopFailed = YES;
            _disAppearingViewController = nil;
        }
        
        self.interactivePopTransition = nil;
    }else{
//        [self resetNavigationTransiton];
    }
    
}

#pragma mark - system private

- (void)startNavigationTransiton
{
    NSString *selectorStr = [NSString stringWithFormat:@"start%@",selecterSuffix];
    if ([_targetTransition respondsToSelector:NSSelectorFromString(selectorStr)]) {
        SuppressPerformSelectorLeakWarning(
                                           [_targetTransition performSelector:NSSelectorFromString(selectorStr)];
                                           );
    }
    selectorStr = [NSString stringWithFormat:@"setNot%@",selecterSuffix];
    SuppressPerformSelectorLeakWarning(
                                       
                                       [_targetTransition performSelector:NSSelectorFromString(selectorStr)];
                                       
                                       );
}


- (void)updateNavigationTransiton:(CGFloat)progress
{
    
    NSString *selectorStr = [NSString stringWithFormat:@"update%@:",selecterSuffix];
    if ([_targetTransition respondsToSelector:NSSelectorFromString(selectorStr)]) {
        SuppressPerformSelectorLeakWarning(
                                           [_targetTransition performSelector:NSSelectorFromString(@"updateInteractiveTransition:")withObject:@(progress)];
                                           );
    }
}

- (void)successCompleteNavigationTransiton
{
    //            [_targetTransition performSelector:NSSelectorFromString(@"_completeStoppedInteractiveTransition")];
    //            [_targetTransition performSelector:NSSelectorFromString(@"finishInteractiveTransition")];
    NSString *selectorStr = [NSString stringWithFormat:@"%@completeStopped%@",selecterPrefix,selecterSuffix];
    SuppressPerformSelectorLeakWarning(
                                       
                                       [_targetTransition performSelector:NSSelectorFromString(selectorStr)];
                                       
                                       );
    selectorStr = [NSString stringWithFormat:@"finish%@",selecterSuffix];
    SuppressPerformSelectorLeakWarning(
                                       
                                       [_targetTransition performSelector:NSSelectorFromString(selectorStr)];
                                       
                                       );
}

- (void)resetNavigationTransiton
{
    NSString *selectorStr = [NSString stringWithFormat:@"%@reset%@",selecterPrefix,@"InteractionController"];
    SuppressPerformSelectorLeakWarning(
                                       
                                       [_targetTransition performSelector:NSSelectorFromString(selectorStr)];
                                       
                                       );
    selectorStr = [NSString stringWithFormat:@"cancel%@",selecterSuffix];
    SuppressPerformSelectorLeakWarning(
                                       
                                       [_targetTransition performSelector:NSSelectorFromString(selectorStr)];
                                       
                                       );
}


@end

//
//  XMNavigationController+PanGesture.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "XMNavigationController+PanGesture.h"
#import "XMNavigationController+Stack.h"


static CGFloat const gestureMinimumTranslation = 10.0;

@interface XMNavigationController (PanGestureControlPrivite)

@property (nonatomic,strong) NSHashTable *hashTable;

@property (nonatomic,assign) XMPanMoveDirection panMoveDirection;

@property (nonatomic,assign) BOOL shouldBegin;

@property (nonatomic,assign) CGPoint startTouch;

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer;

@end


@implementation XMNavigationController (PanGesture)

#pragma mark - UIPanGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (NO == self.isPanValid)
    {
        return NO;
    }
    
    //other operation
    
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    [self.hashTable removeAllObjects];
    
    if ([self.topViewController respondsToSelector:@selector(navigationGestureRecognizer:shouldReceiveTouch:)])
    {
        return [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController navigationGestureRecognizer:gestureRecognizer
                                                                                            shouldReceiveTouch:touch];
    }
    else
    {
        if([touch.view isKindOfClass:[UISlider class]])
        {
            // 解决UISlider和Pan手势冲突的问题
            return  NO;
        }
        
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([self.topViewController respondsToSelector:@selector(backRecognizerResolvedBySystem)])
    {
        result =  [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController backRecognizerResolvedBySystem];
    }
    
    if (!result)
    {
        [self.hashTable addObject:otherGestureRecognizer];
    }
    
    return !result;
    
}

#pragma mark - 移动方法

- (void)moveViewWithX:(float)x
{
    CGRect frame = [self topViewController].view.frame;
    frame.origin.x = x;
    [self topViewController].view.frame = frame;
    
    float scale = (fabsf(x)/6400)+0.95;
    float alpha = 0.4 - (fabsf(x)/800);
    scale = scale > 1.0 ? 1.0:scale;
    self.maskView.alpha = alpha;
    [self belowViewController].view.transform = CGAffineTransformMakeScale(scale, scale);
    
    
}


- (void)moveViewWithY:(float)y
{
    CGRect frame = [self topViewController].view.frame;
    frame.origin.y = y;
    [self topViewController].view.frame = frame;
    
    float scale = (fabsf(y)/6400)+0.95;
    float alpha = 0.4 - (fabsf(y)/800);
    
    scale = scale > 1.0 ? 1.0:scale;
    
    self.maskView.alpha = alpha;
    
    [self belowViewController].view.transform = CGAffineTransformMakeScale(scale, scale);
}

#pragma mark - 识别方向
- (XMPanMoveDirection)determinePanDirectionIfNeeded:( CGPoint )translation
{
    if (fabs(translation.x) > gestureMinimumTranslation)
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
        {
            gestureHorizontal = YES;
        }
        else
        {
            gestureHorizontal = (fabs(translation.x / translation.y) > 2.0 );
        }
        
        if (gestureHorizontal)
        {
            if (translation.x > 0.0 )
            {
                return kXMPanMoveDirectionRight;
            }
            else
            {
                return kXMPanMoveDirectionLeft;
            }
        }
        
    }
    
    if (fabs(translation.y) > gestureMinimumTranslation)
    {
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
        {
            gestureVertical = YES;
        }
        else
        {
            gestureVertical = (fabs(translation.y / translation.x) > 2.0 );
        }
        
        if (gestureVertical)
        {
            if (translation.y > 0.0 )
            {
                return kXMPanMoveDirectionDown;
            }
            else
            {
                return kXMPanMoveDirectionUp;
            }
        }
    }
    
    return kXMPanMoveDirectionNone;
    
}

#pragma mark- Gesture Recognizer
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1)
    {
        return;
    }
    
    if (self.isPanValid) //已经 开启手势支持
    {
        CGPoint translation = [recoginzer translationInView: self.view];
        
        CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
        
        if (recoginzer.state == UIGestureRecognizerStateBegan) //开始识别手势
        {
            
            self.panMoveDirection = kXMPanMoveDirectionNone;
            
            self.startTouch = touchPoint;
            
            self.shouldBegin = NO;
            
            UIViewController *topViewController = [self topViewController];
            UIViewController *beViewController = [self belowViewController];
            if (topViewController == beViewController)
            {
                return;
            }
            
            [topViewController.view.superview insertSubview:beViewController.view belowSubview:topViewController.view];
            beViewController.view.hidden = NO;
            [self.maskView.superview insertSubview:self.maskView
                                      belowSubview:[self topViewController].view];
            
            
            if ([self.viewControllers count] >= 2)
            {
                [self.animationView.superview insertSubview:self.animationView belowSubview:beViewController.view];
            }
            
            self.maskView.alpha = 0.7;
            
        }
        else if (recoginzer.state == UIGestureRecognizerStateChanged) //移动
        {
            //未识别出方向
            if (self.panMoveDirection == kXMPanMoveDirectionNone)
            {
                self.panMoveDirection = [self determinePanDirectionIfNeeded:translation];
            }
            
            //已经识别方向
            if (self.panMoveDirection != kXMPanMoveDirectionNone)
            {
                //默认支持向右滑动返回
                XMPanMoveDirection supportDirection = kXMPanMoveDirectionRight;
                
                if ([self.topViewController respondsToSelector:@selector(supportNavigationBackDirection)])
                {
                    //获取controller 支持的滑动返回方向
                    supportDirection = [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController  supportNavigationBackDirection];
                }
                
                //如果controller 不支持此方向滑动返回，则取消本次手势
                if ((supportDirection & self.panMoveDirection) != self.panMoveDirection)
                {
                    recoginzer.enabled = NO;
                    recoginzer.enabled = YES;
                    
                    return;
                }
                
                //判断controller是否实现条件滑动返回方法并且为开始执行滑动
                if ([self.topViewController respondsToSelector:@selector(navigationBackCanBeginWithDirection:gestureRecognizer:)] && !self.shouldBegin)
                {
                    
                    id<UIViewControllerInXMNavigationProtocol> viewcontroller =(id<UIViewControllerInXMNavigationProtocol>) self.topViewController;
                    
                    self.shouldBegin = YES;
                    for(UIGestureRecognizer * gestureRecognizer in self.hashTable)
                    {
                        self.shouldBegin = [viewcontroller navigationBackCanBeginWithDirection:self.panMoveDirection gestureRecognizer:gestureRecognizer];
                        
                        if (self.shouldBegin == NO)
                        {
                            break;
                        }
                    }
                    
                    if (self.shouldBegin)
                    {
                        self.startTouch = touchPoint;
//                        [self adjustTabBar:nil];
                        
                        UIViewController *viewController= [self topViewController];
                        
                        if ([viewController respondsToSelector:@selector(navigationController:panBackBeginInWithController:)])
                        {
                            [(id<UIViewControllerInXMNavigationProtocol>)viewController navigationController:self
                                                                                panBackBeginInWithController:viewController];
                        }
                        
                        //取消其他手势
                        for(UIGestureRecognizer * gestureRecognizer in self.hashTable.allObjects)
                        {
                            gestureRecognizer.enabled = NO;
                            gestureRecognizer.enabled = YES;
                        }
                        [self.hashTable removeAllObjects];
                        
                        if (self.panMoveDirection == kXMPanMoveDirectionLeft || self.panMoveDirection == kXMPanMoveDirectionRight)
                        {
                            CGFloat increase;
                            increase = touchPoint.x - self.startTouch.x;
                            
                            if ((increase < 0 && self.panMoveDirection == kXMPanMoveDirectionRight))
                            {
                                increase = 0;
                            }
                            
                            if ((increase > 0 && self.panMoveDirection == kXMPanMoveDirectionLeft))
                            {
                                increase = 0;
                            }
                            [self moveViewWithX:increase];
                        }
                        else
                        {
                            
                            CGFloat increase = touchPoint.y - self.startTouch.y;
                            
                            if ((increase < 0 && self.panMoveDirection == kXMPanMoveDirectionDown))
                            {
                                increase = 0;
                            }
                            
                            if ((increase > 0 && self.panMoveDirection == kXMPanMoveDirectionUp))
                            {
                                increase = 0;
                            }
                            [self moveViewWithY:increase];
                        }
                        
                    }
                }
                else
                {
                    if (!self.shouldBegin)
                    {
                        UIViewController *viewController= [self topViewController];
                        
//                        [self adjustTabBar:nil];
                        
                        if ([viewController respondsToSelector:@selector(navigationController:panBackBeginInWithController:)])
                        {
                            [(id<UIViewControllerInXMNavigationProtocol>)viewController navigationController:self
                                                                                panBackBeginInWithController:viewController];
                        }
                    }
                    
                    self.shouldBegin = YES;
                    
                    //取消其他手势
                    for(UIGestureRecognizer * gestureRecognizer in self.hashTable)
                    {
                        
                        gestureRecognizer.enabled = NO;
                        gestureRecognizer.enabled = YES;
                    }
                    [self.hashTable removeAllObjects];
                    
                    
                    if (self.panMoveDirection == kXMPanMoveDirectionLeft || self.panMoveDirection == kXMPanMoveDirectionRight)
                    {
                        
                        CGFloat increase = touchPoint.x - self.startTouch.x;
                        
                        if ((increase < 0 && self.panMoveDirection == kXMPanMoveDirectionRight))
                        {
                            increase = 0;
                        }
                        
                        if ((increase > 0 && self.panMoveDirection == kXMPanMoveDirectionLeft))
                        {
                            increase = 0;
                        }
                        
                        [self moveViewWithX:increase];
                    }
                    else
                    {
                        CGFloat increase = touchPoint.y - self.startTouch.y;
                        
                        if ((increase < 0 && self.panMoveDirection == kXMPanMoveDirectionDown))
                        {
                            increase = 0;
                        }
                        
                        if ((increase > 0 && self.panMoveDirection == kXMPanMoveDirectionUp))
                        {
                            increase = 0;
                        }
                        [self moveViewWithY:increase];
                    }
                    
                }
                
                
                self.paning = YES;
                
            }
            
        }
        else if (recoginzer.state == UIGestureRecognizerStateEnded || recoginzer.state == UIGestureRecognizerStateCancelled)
        {
            self.paning = NO;
            
            [self.hashTable removeAllObjects];
            
            UIViewController *viewController= [self topViewController];
            
            if (!self.shouldBegin) //若未为开始移动
            {
                [self moveViewWithX:0];
                [self moveViewWithY:0];
                [self resetAllViewStatusOnEndPanAnimation];
                
                return;
            }
            else
            {
                
                if (self.panMoveDirection == kXMPanMoveDirectionRight || self.panMoveDirection == kXMPanMoveDirectionLeft )//横向滑动
                {
                    if (fabs(touchPoint.x - self.startTouch.x) > 50 &&
                        fabs([self topViewController].view.frame.origin.x) > 50)
                    {
                        self.view.userInteractionEnabled = NO;
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            [self moveViewWithX:(self.panMoveDirection == kXMPanMoveDirectionRight)?[UIScreen mainScreen].bounds.size.width:0-[UIScreen mainScreen].bounds.size.width];
                            
                        } completion:^(BOOL finished)
                         {
                             
                             if ([viewController respondsToSelector:@selector(navigationController:panBackEndInWithController:)])
                             {
                                 [(id<UIViewControllerInXMNavigationProtocol>)viewController navigationController:self
                                                                                       panBackEndInWithController:viewController];
                             }
                             [self popViewControllerAnimated:NO];
                             
                             [self resetAllViewStatusOnEndPanAnimation];
                             
                             
                         }];
                    }
                    else
                    {
                        self.view.userInteractionEnabled = NO;
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            [self moveViewWithX:0];
                        } completion:^(BOOL finished) {
                            if ([viewController respondsToSelector:@selector(navigationController:panBackCannelInWithController:)])
                            {
                                [(id<UIViewControllerInXMNavigationProtocol>)viewController navigationController:self
                                                                                   panBackCannelInWithController:viewController];
                            }
                            
                            [self resetAllViewStatusOnEndPanAnimation];
                            self.topViewController.view.frame = self.view.bounds;
                            
                        }];
                    }
                    
                }
                else  if (self.panMoveDirection == kXMPanMoveDirectionDown ||self.panMoveDirection == kXMPanMoveDirectionUp ) //纵向滑动
                    
                {
                    if (fabs(touchPoint.y - self.startTouch.y) > 50 && fabs([self topViewController].view.frame.origin.y) > 50)
                    {
                        self.view.userInteractionEnabled = NO;
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            [self moveViewWithY:(self.panMoveDirection == kXMPanMoveDirectionDown)?[UIScreen mainScreen].bounds.size.height : 0-[UIScreen mainScreen].bounds.size.height];
                        } completion:^(BOOL finished) {
                            
                            if ([viewController respondsToSelector:@selector(navigationController:panBackEndInWithController:)])
                            {
                                [(id<UIViewControllerInXMNavigationProtocol>)viewController navigationController:self
                                                                                      panBackEndInWithController:viewController];
                            }
                            [self popViewControllerAnimated:NO];
                            
                            [self resetAllViewStatusOnEndPanAnimation];
                            
                        }];
                    }
                    else
                    {
                        self.view.userInteractionEnabled = NO;
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            [self moveViewWithY:0];
                            
                        } completion:^(BOOL finished) {
                            if ([viewController respondsToSelector:@selector(navigationController:panBackCannelInWithController:)])
                            {
                                [(id<UIViewControllerInXMNavigationProtocol>)viewController navigationController:self
                                                                                   panBackCannelInWithController:viewController];
                            }
                            
                            [self resetAllViewStatusOnEndPanAnimation];
                            self.topViewController.view.frame = self.view.bounds;
                            
                            
                        }];
                    }
                    
                }
                self.panMoveDirection = kXMPanMoveDirectionNone;
                
                self.shouldBegin = NO;
                
            }
            return;
        }
    }
}


- (void)resetSubViewFrame
{
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL * _Nonnull stop) {
        if(viewController != self.topViewController && viewController.isViewLoaded)
        {
            viewController.view.frame = self.view.bounds;
        }
    }];
}


- (void)resetAllViewStatusOnEndPanAnimation
{
    self.belowViewController.view.transform = CGAffineTransformIdentity;
    self.topViewController.view.transform = CGAffineTransformIdentity;
    [self resetSubViewFrame];
    [self.animationView.superview insertSubview:self.animationView atIndex:0];
//    [self resetTabBar];
    self.view.userInteractionEnabled = YES;
}

@end

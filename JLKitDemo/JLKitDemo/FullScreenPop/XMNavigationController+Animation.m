//
//  XMNavigationController+Animation.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "XMNavigationController+Animation.h"
#import "UIViewController+XMNavigationController.h"


@interface XMNavigationController ()

@property (nonatomic, assign, readwrite,getter = isLayouting) BOOL layouting;

@end

@implementation XMNavigationController (Animation)
//#if USEAHNavigationController == 1

- (void)prepareForAnimationFromViewController:(UIViewController *)fromViewController
                             toViewController:(UIViewController *)toViewController
                                         push:(BOOL)isPush
{
    
    toViewController.view.hidden = NO;
    fromViewController.view.hidden = NO;
    
    if (isPush)
    {
        [fromViewController.view.superview bringSubviewToFront:fromViewController.view];
        [self.maskView.superview bringSubviewToFront:self.maskView];
        [toViewController.view.superview bringSubviewToFront:toViewController.view];
    }
    else
    {
        [toViewController.view.superview bringSubviewToFront:toViewController.view];
        [self.maskView.superview bringSubviewToFront:self.maskView];
        [fromViewController.view.superview bringSubviewToFront:fromViewController.view];
    }
    
    
}

- (void)pushAnimationType:(XMNavigationViewAnimationType)animationType
       fromViewController:(UIViewController *)fromViewController
         toViewController:(UIViewController *)toViewController
             onCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    if(self.layouting)
    {
        if (completionBlock)
        {
            completionBlock();
        }
        return;
    }
    
    BOOL tempOldValue = self.isPanValid;
    
    self.panValid = NO;
    self.view.userInteractionEnabled = NO;;
    self.layouting = YES;
    
    CGRect toViewControllerBeginRect = toViewController.view.frame;
    CGRect toViewControllerEndRect   = toViewController.view.frame;
    
    CGRect fromViewControllerBeginRect = fromViewController.view.frame;
    CGRect fromViewControllerEndRect   = fromViewController.view.frame;
    
    CGFloat maskViewEndAlpha = 0.7;
    
    self.maskView.alpha = 0.0;
    
    [self prepareForAnimationFromViewController:fromViewController toViewController:toViewController push:YES];
    
    switch (animationType)
    {
        case XMNavigationViewAnimationTypeNone:
            break;
        case XMNavigationViewAnimationTypeRightToLeft:
            toViewControllerBeginRect.origin = CGPointMake(CGRectGetWidth(self.view.frame), 0);
            //            fromViewControllerEndRect.origin = CGPointMake(- CGRectGetWidth(self.view.frame)/2.0, 0);
            break;
        case XMNavigationViewAnimationTypeLeftToRight:
            toViewControllerBeginRect.origin = CGPointMake(- CGRectGetWidth(self.view.frame), 0);
            //            fromViewControllerEndRect.origin = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, 0);
            break;
        case XMNavigationViewAnimationTypeTopToBottom:
            toViewControllerBeginRect.origin = CGPointMake(0, - CGRectGetHeight(self.view.frame));
            //            fromViewControllerEndRect.origin = CGPointMake(0, CGRectGetHeight(self.view.frame)/2.0);
            break;
            
        case XMNavigationViewAnimationTypeBottomToTop:
            toViewControllerBeginRect.origin = CGPointMake(0, CGRectGetHeight(self.view.frame));
            //            fromViewControllerEndRect.origin = CGPointMake(0, - CGRectGetHeight(self.view.frame)/2.0);
            break;
            
            
        default:
            toViewControllerBeginRect.origin = CGPointMake(CGRectGetWidth(self.view.frame), 0);
            //            fromViewControllerEndRect.origin = CGPointMake(- CGRectGetWidth(self.view.frame)/2.0, 0);
            break;
    }
    
    
    fromViewController.view.frame = fromViewControllerBeginRect;
    toViewController.view.frame = toViewControllerBeginRect;
    
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         
                         toViewController.view.frame = toViewControllerEndRect;
                         fromViewController.view.frame = fromViewControllerEndRect;
                         self.maskView.alpha = maskViewEndAlpha;
                         
                     }
                     completion:^(BOOL finished)
     {
         fromViewController.view.frame = self.view.bounds;
         
         self.panValid = tempOldValue;
         if (completionBlock)
         {
             completionBlock();
         }
         
         self.view.userInteractionEnabled = YES;;
         self.layouting = NO;
         
     }];
    
    
    
}



- (void)popAnimationType:(XMNavigationViewAnimationType)animationType
      fromViewController:(UIViewController *)fromViewController
        toViewController:(UIViewController *)toViewController
            onCompletion:(XMNavigationAnimationCompletionBlock)completionBlock
{
    if(self.layouting)
    {
        if (completionBlock)
        {
            completionBlock();
        }
        return;
    }
    self.view.userInteractionEnabled = NO;;
    self.layouting = YES;
    
    toViewController.pushAnimationType = XMNavigationViewAnimationTypeNone;
    
    CGRect toViewControllerBeginRect = toViewController.view.frame;
    CGRect toViewControllerEndRect   = toViewController.view.frame;
    
    CGRect fromViewControllerBeginRect = fromViewController.view.frame;
    CGRect fromViewControllerEndRect   = fromViewController.view.frame;
    
    CGFloat maskViewEndAlpha = 0.0;
    
    self.maskView.alpha = 0.7;
    
    [self prepareForAnimationFromViewController:fromViewController toViewController:toViewController push:NO];
    
    switch (animationType)
    {
        case XMNavigationViewAnimationTypeNone:
            break;
        case XMNavigationViewAnimationTypeLeftToRight:
            fromViewControllerEndRect.origin = CGPointMake(CGRectGetWidth(self.view.frame), 0);
            toViewControllerBeginRect.origin = CGPointMake(- CGRectGetWidth(self.view.frame)/5.0, 0);
            break;
            
        case XMNavigationViewAnimationTypeRightToLeft:
            fromViewControllerEndRect.origin = CGPointMake(-CGRectGetWidth(self.view.frame), 0);
            //            toViewControllerBeginRect.origin = CGPointMake(CGRectGetWidth(self.view.frame)/5.0, 0);
            break;
            
        case XMNavigationViewAnimationTypeTopToBottom:
            fromViewControllerEndRect.origin = CGPointMake(0, CGRectGetHeight(self.view.frame));
            //            toViewControllerBeginRect.origin = CGPointMake(0, -CGRectGetHeight(self.view.frame)/5.0);
            break;
            
        case XMNavigationViewAnimationTypeBottomToTop:
            fromViewControllerEndRect.origin = CGPointMake(0, -CGRectGetHeight(self.view.frame));
            //            toViewControllerBeginRect.origin = CGPointMake(0, CGRectGetHeight(self.view.frame)/5.0);
            break;
        default:
            fromViewControllerEndRect.origin = CGPointMake(CGRectGetWidth(self.view.frame), 0);
            //            toViewControllerBeginRect.origin = CGPointMake(- CGRectGetWidth(self.view.frame)/5.0, 0);
            break;
    }
    
    fromViewController.view.frame = fromViewControllerBeginRect;
    toViewController.view.frame = toViewControllerBeginRect;
    
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         
                         toViewController.view.frame = toViewControllerEndRect;
                         fromViewController.view.frame = fromViewControllerEndRect;
                         self.maskView.alpha = maskViewEndAlpha;
                         
                     }
                     completion:^(BOOL finished)
     {
         toViewController.view.transform = CGAffineTransformIdentity;
         fromViewController.view.transform = CGAffineTransformIdentity;
         toViewController.view.frame = self.view.bounds;
         fromViewController.view.frame = self.view.bounds;
         
         [self.maskView.superview insertSubview:self.maskView belowSubview:toViewController.view];
         
         if (completionBlock)
         {
             completionBlock();
         }
         
         self.view.userInteractionEnabled = YES;;
         self.layouting = NO;
         
     }];
    
    
}


//#endif

@end

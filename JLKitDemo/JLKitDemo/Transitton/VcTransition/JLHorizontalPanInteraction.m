//
//  JLHorizontalPanInteraction.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/26.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLHorizontalPanInteraction.h"
#import <objc/runtime.h>

const NSString *kJLHorizontalSwipeGestureKey = @"kJLHorizontalSwipeGestureKey";

@interface JLHorizontalPanInteraction()
{
    BOOL _shouldCompleteTransition;
    UIViewController *_viewController;
    JLInteractionOperation _operation;
}

@end


@implementation JLHorizontalPanInteraction


- (void)wireToViewController:(UIViewController *)viewController forOperation:(JLInteractionOperation)operation{
    self.popOnLeftToRight = YES;
    _operation = operation;
    _viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(view, (__bridge const void *)(kJLHorizontalSwipeGestureKey));
    
    if (gesture) {
        [view removeGestureRecognizer:gesture];
    }
    
    
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
    
    objc_setAssociatedObject(view, (__bridge const void *)(kJLHorizontalSwipeGestureKey), gesture,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGPoint vel = [gestureRecognizer velocityInView:gestureRecognizer.view];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            //控制手势滑动的方向
            BOOL leftToRightToLeftPan = vel.x < 0;
            
            // perform the required navigation operation ...
            
            if (_operation == JLInteractionOperationPop) {
                // for pop operation, fire on right-to-left
                if ((self.popOnLeftToRight && leftToRightToLeftPan) ||
                    (!self.popOnLeftToRight && !leftToRightToLeftPan)) {
                    self.interactionInProgress = YES;
                    [_viewController.navigationController popViewControllerAnimated:YES];
                }
            } else if (_operation == JLInteractionOperationTab) {
                // for tab controllers, we need to determine which direction to transition
                if (leftToRightToLeftPan) {
                    if (_viewController.tabBarController.selectedIndex < _viewController.tabBarController.viewControllers.count - 1) {
                        self.interactionInProgress = YES;
                        _viewController.tabBarController.selectedIndex++;
                    }
                    
                } else {
                    if (_viewController.tabBarController.selectedIndex > 0) {
                        self.interactionInProgress = YES;
                        _viewController.tabBarController.selectedIndex--;
                    }
                }
            } else {
                // for dismiss, fire regardless of the translation direction
                self.interactionInProgress = YES;
                [_viewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.interactionInProgress) {
                // compute the current position
                CGFloat fraction = fabs(translation.x / 200.0);
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                _shouldCompleteTransition = (fraction > 0.5);
                
                // if an interactive transitions is 100% completed via the user interaction, for some reason
                // the animation completion block is not called, and henJL the transition is not completed.
                // This glorious hack makes sure that this doesn't happen.
                // see: https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
                if (fraction >= 1.0)
                    fraction = 0.99;
                
                [self updateInteractiveTransition:fraction];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
}

@end

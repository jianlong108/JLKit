//
//  JLBaseInteractiveTransition.h
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/26.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JLInteractionOperation) {
    
    JLInteractionOperationPop,
    
    JLInteractionOperationDismiss,
    
    JLInteractionOperationTab
};

@interface JLBaseInteractiveTransition : UIPercentDrivenInteractiveTransition

- (void)wireToViewController:(UIViewController*)viewController forOperation:(JLInteractionOperation)operation;


@property (nonatomic, assign) BOOL interactionInProgress;

@end

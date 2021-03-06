//
//  TwoFaceButton.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwoFaceButton : UIView

/**正面button
 * 无需设置frame positiveBtn.frame == self.bounds
 */
@property (nonatomic, readonly) UIButton *positiveBtn;

/**反面button
 * 无需设置frame oppositeBtn.frame == self.bounds
 */
@property (nonatomic, readonly) UIButton *oppositeBtn;

/**动画时间
 * 默认 0.5s
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**动画类型
 * UIViewAnimationOptionTransitionFlipFromLeft
 */
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;

/**支持自旋转
 * 点击按钮后,是否自动翻转,默认YES
 */
@property (nonatomic, assign) BOOL autoTransition;


/**
 翻转view 以设定好的动画,动画时间.
 */
- (void)transitionView;

/**
 翻转view 从正面翻转到反面
 */
- (void)transitionFromPositiveViewToOppositeView;

/**
 翻转view 从反面翻转到正面
 */
- (void)transitionFromOppositeViewToPositiveView;

@end

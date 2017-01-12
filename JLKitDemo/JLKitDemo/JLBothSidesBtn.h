//
//  JLBothSidesView.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JLBothSidesBtn : UIView

/**正面button
 * 无需设置frame positiveBtn.frame == self.bounds
 */
@property (nonatomic, strong,readonly)UIButton *positiveBtn;

/**反面button
 * 无需设置frame oppositeBtn.frame == self.bounds
 */
@property (nonatomic, strong,readonly)UIButton *oppositeBtn;

/**动画时间
 * 默认 0.5s
 */
@property (nonatomic, assign)NSTimeInterval animationDuration;

/**动画类型
 * UIViewAnimationOptionTransitionFlipFromLeft
 */
@property (nonatomic, assign)UIViewAnimationOptions animationOptions;

/**支持自旋转
 * 点击按钮后,是否自动翻转,默认YES
 */
@property (nonatomic, assign)BOOL autoTransition;


/**
 翻转view 以设定好的动画,动画时间.
 */
- (void)transitionView;


@end

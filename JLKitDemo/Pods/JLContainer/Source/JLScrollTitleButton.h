//
//  JLScrollTitleButton.h
//  JLContainer
//
//  Created by wangjianlong on 2018/5/14.
//

#import <UIKit/UIKit.h>

@interface JLScrollTitleButton : UIButton

/**红点*/
@property (nonatomic, strong) UIView *redDot;

@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;

/**红点半径*/
@property (nonatomic, assign) CGFloat redDot_Radius;

/**右上角的文字(数字)提示*/
@property (nonatomic, strong) UILabel *alertLabel;

/**文字(数字)提示 半径*/
@property (nonatomic, assign) CGFloat alertLabel_Radius;

/**文字提示 显示的内容*/
@property (nonatomic, copy) NSString *alertLabelText;

@end

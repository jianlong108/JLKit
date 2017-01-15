//
//  JLCellitem.h
//  JLKit
//  Created by Wangjianlong on 16/6/13.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLCellitem : UIButton

/**
 *  需要显示的标题，标题和图片可以都设置也可只设置一个
 */
@property (nonatomic, strong) NSString *title;

/**
 *  字体的默认颜色是黑色,可设置
 */
@property (nonatomic, strong)UIColor *titleColor;

/**
 *  需要显示的图片，标题和图片可以都设置也可只设置一个
 */
@property (nonatomic, strong) UIImage  *image;

/**
 *  选中时需要显示的图片
 */
@property (nonatomic, strong) UIImage  *selectedImage;

/**
 *  UIControlStateHighlighted 时显示的图片
 */
@property (nonatomic, strong) UIImage  *highlightedImage;

/**
 *  标题字体，可不设置，使用默认字体
 */
@property (nonatomic, strong) UIFont   *titleFont;

/**
 *  imageView与上边界的间距 默认5
 */
@property (nonatomic, assign)CGFloat topMargin;

/**
 *  titleLabel与下边界的间距 默认5
 */
@property (nonatomic, assign)CGFloat bottomMargin;

/**禁止使用*/
@property (nonatomic, assign)BOOL  prohibitUse;

/**使用之后,item不能移动,交换,但是可以响应点击*/
@property (nonatomic, assign)BOOL  onlyClick;

@end

//
//  JLTextFiled.h
//  JLKitDemo
//
//  Created by 王建龙 on 2017/11/16.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JLTextFiled : UITextField

/**文字的相对偏移量
 @ warning 控制placeholder 和 editing 的rect
 */
@property (nonatomic, assign)  UIOffset textOriginOffset;

@end

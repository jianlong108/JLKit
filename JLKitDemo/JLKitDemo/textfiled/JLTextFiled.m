//
//  JLTextFiled.m
//  JLKitDemo
//
//  Created by 王建龙 on 2017/11/16.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLTextFiled.h"

@implementation JLTextFiled
//- (CGRect)borderRectForBounds:(CGRect)bounds{
//
//    NSLog(@"%s",__func__);
////    return [super borderRectForBounds:bounds];
//    CGRect superFrame = [super borderRectForBounds:bounds];
//
//    return CGRectOffset(superFrame, 20, 0);
//}
- (CGRect)textRectForBounds:(CGRect)bounds{
//    NSLog(@"%s",__func__);
    CGRect superFrame = [super textRectForBounds:bounds];
    return CGRectMake(superFrame.origin.x + self.textOriginOffset.horizontal, superFrame.origin.y + self.textOriginOffset.vertical, superFrame.size.width - 2*self.textOriginOffset.horizontal,  superFrame.size.height - 2*self.textOriginOffset.vertical);
}

/**
 placeholder在UITextField中的位置是以输入文字光标的上端点作为它的显示位置，
 所以当我们设置的placeholder字体大小与textField设置的输入文字大小有差异时，
 placeholder的显示位置就不会垂直居中而发生向下偏移 
 */
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
//    NSLog(@"%s",__func__);
    return [super placeholderRectForBounds:bounds];
}
- (CGRect)editingRectForBounds:(CGRect)bounds{
//    NSLog(@"%s",__func__);
    return [self textRectForBounds:bounds];
}
//- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
//    NSLog(@"%s",__func__);
//    return [super clearButtonRectForBounds:bounds];
//}
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    NSLog(@"%s",__func__);
    CGRect superFrame = [super leftViewRectForBounds:bounds];
    return CGRectMake(0, 0, CGRectGetHeight(bounds)  , CGRectGetHeight(bounds));
    
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    NSLog(@"%s",__func__);
    
    return CGRectMake(0, 0, CGRectGetHeight(bounds)  , CGRectGetHeight(bounds));
}

@end

//
//  JLScrollTitleButton.m
//  JLContainer
//
//  Created by wangjianlong on 2018/5/14.
//

#import "JLScrollTitleButton.h"

@interface JLScrollTitleButton()


@end

@implementation JLScrollTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _redDot_Radius = 6 / 2;
        _alertLabel_Radius = 14;
        
        _redDot = [[UIView alloc]init];
        _redDot.hidden = YES;
        _redDot.layer.cornerRadius = _redDot_Radius;
        _redDot.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        [self addSubview:_redDot];
        
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _alertLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        _alertLabel.font = [UIFont systemFontOfSize:9];
        _alertLabel.hidden = YES;
        [self addSubview:_alertLabel];
        [self bringSubviewToFront:_alertLabel];
        
        self.titleLabel.lineBreakMode = NSLineBreakByClipping;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect titleRect = [super titleRectForContentRect:contentRect];
    _redDot.frame = CGRectMake(CGRectGetMaxX(titleRect), CGRectGetMinY(titleRect) - _redDot_Radius, _redDot_Radius*2, _redDot_Radius*2);
    
    _alertLabel.frame = CGRectMake((int)CGRectGetMaxX(titleRect), CGRectGetMinY(titleRect) - 7, _alertLabel_Radius, 14.0);
    [self bringSubviewToFront:_alertLabel];
    
    return titleRect;
}
- (void)setAlertLabelText:(NSString *)alertLabelText{
    if ([alertLabelText isEqualToString:@""]||alertLabelText == nil) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9.0], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:alertLabelText attributes:attributes];
    CGSize tempSize = [attributeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _alertLabel.text = alertLabelText;
    _alertLabel_Radius = tempSize.width + 10;
    if (_alertLabel_Radius < 14) {
        _alertLabel_Radius = 14;
    }
    
    _alertLabel.frame = CGRectMake((int)CGRectGetMaxX(_alertLabel.frame) - 4, CGRectGetMinY(_alertLabel.frame) - 7, _alertLabel_Radius, 14.0);
    
    if ([self isNum:alertLabelText]) {
        
        /** 是数字*/
        _alertLabel.layer.cornerRadius = 7;
        _alertLabel.layer.masksToBounds = YES;
    }else {
        
        /** 不是数字*/
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_alertLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _alertLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _alertLabel.layer.mask = maskLayer;
    }
    
    [self setNeedsLayout];
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void)setNormalFont:(UIFont *)normalFont
{
    _normalFont = normalFont;
    [self.titleLabel setFont:_normalFont];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = self.selectedFont;
    } else {
        self.titleLabel.font = self.normalFont;
    }
}

@end

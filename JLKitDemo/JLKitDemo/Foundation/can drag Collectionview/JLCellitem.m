//
//  JLCellitem.m
//  JLKit
//  Created by Wangjianlong on 16/6/13.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import "JLCellitem.h"
//#import "UIColor+HexString.h"
//#import "UIImage+Extensions.h"

#define kAHTabBarItemImgTitleInterval    0.5


@implementation JLCellitem
- (void)setImage:(UIImage *)image
{
    _image = image;

    [self setImage:image forState:UIControlStateNormal];
}



- (void)setTitle:(NSString *)title
{
    _title = title;

    [self setTitle:title forState:UIControlStateNormal];
}


- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;

    [self.titleLabel setFont:titleFont];
    

}

- (void)setHighlightedImage:(UIImage *)highlightedImage{
    _highlightedImage = highlightedImage;
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage{
    _selectedImage = selectedImage;
    [self setImage:selectedImage forState:UIControlStateSelected];
}

-(instancetype)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeCenter;
        
//        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal];
//        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f0eff5"]] forState:UIControlStateHighlighted];
//        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f0eff5"]] forState:UIControlStateSelected];
        self.topMargin = 5.0f;
        self.bottomMargin = 5.0f;
        [self setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f] forState:UIControlStateNormal];
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
   
    UIImage *tempImage = self.image;
    
    
    return CGRectMake((contentRect.size.width - tempImage.size.width)/2, _topMargin, tempImage.size.width, tempImage.size.height);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = contentRect;
   
    if (self.image)
    {
        CGFloat height = [self stringSizeStr:self.title].height;
        return CGRectMake(0, contentRect.size.height - height -_bottomMargin, contentRect.size.width,height);
    }
    
    return titleRect;
}


#pragma clang diagnostic pop
- (CGSize)stringSizeStr:(NSString *)str{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:_titleFont?_titleFont:[UIFont systemFontOfSize:15.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    
    CGSize tempSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return tempSize;
}
@end

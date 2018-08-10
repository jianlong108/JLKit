//
//  MTTableViewSectionIndexBar.m
//  MiTalk
//
//  Created by 王建龙 on 2017/11/29.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MTTableViewSectionIndexBar.h"


#define bigTitleMarginWithLetter 10

static NSString *const letter_key             = @"MTTableViewSectionIndexBar_letter_key";
static NSString *const letterColor_normal_key = @"MTTableViewSectionIndexBar_letterColor_normal_key";
static NSString *const letter_rect_key        = @"MTTableViewSectionIndexBar_letter_rect_key";


@interface MTTableViewSectionIndexBar()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, weak)   UILabel *bigTitleLabel;
@property (nonatomic, weak)   UIImageView *bigTitleBackgImgView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@property (nonatomic, assign) CGFloat letterMargin;
@property (nonatomic, assign) CGFloat selectLetterBack_WH;
@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) NSUInteger selectIndex;
@property (nonatomic, weak)   UILabel *selectedBgView;

#if __IPHONE_10_0
@property (nonatomic, strong) UISelectionFeedbackGenerator *motorGenerator;
#else
#endif

@end

@implementation MTTableViewSectionIndexBar

- (instancetype)initWith:(UITableView *)view andTitles:(NSArray *)titleArray{
    UIView *superView = view.superview;
    if (superView == nil) {
        return nil;
    }
    CGRect rect = [self preCalculateParameterWithSuperView:view count:titleArray.count];
    
    self = [self initWithFrame:rect];
    if (self) {
        _selectIndex = NSUIntegerMax;
        if (@available(iOS 10.0,*)) {
            _motorGenerator = [[UISelectionFeedbackGenerator alloc]init];
            [_motorGenerator prepare];
        }
        NSMutableDictionary *dic;
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        for (NSString *letter in titleArray) {
            dic = [NSMutableDictionary dictionary];
            [dic setObject:letter forKey:letter_key];
            [dic setObject:[[UIColor blackColor] colorWithAlphaComponent:0.4]forKey:letterColor_normal_key];
            [dataArray addObject:dic];
        }
        _titles = [dataArray copy];
        
        
        self.backgroundColor = [UIColor clearColor];
        [superView insertSubview:self aboveSubview:view];
        
        UILabel *selectedBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _selectLetterBack_WH, _selectLetterBack_WH)];
        selectedBgLabel.textColor = [UIColor whiteColor];
        selectedBgLabel.backgroundColor = [UIColor clearColor];
        selectedBgLabel.font = _letterFont;
        selectedBgLabel.textAlignment = NSTextAlignmentCenter;
        selectedBgLabel.layer.cornerRadius = _selectLetterBack_WH/2;
        selectedBgLabel.layer.masksToBounds = YES;
        [self insertSubview:selectedBgLabel atIndex:0];
        selectedBgLabel.hidden = YES;
        
        _selectedBgView = selectedBgLabel;
        
        UIImageView *bigTitleLabelBackImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"message_address_book_search_bg"]];
        bigTitleLabelBackImgView.bounds = CGRectMake(0, 0, 78, 60);
        bigTitleLabelBackImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        UILabel *bigtitleLable   = [[UILabel alloc] init];
        bigtitleLable.backgroundColor = [UIColor clearColor];
        [bigtitleLable setTextColor:[UIColor whiteColor]];
        bigtitleLable.font = [UIFont systemFontOfSize:28];
        [bigtitleLable setTextAlignment:NSTextAlignmentCenter];
        bigtitleLable.frame = bigTitleLabelBackImgView.bounds;
        [bigTitleLabelBackImgView addSubview:bigtitleLable];
        [superView addSubview:bigTitleLabelBackImgView];
        bigTitleLabelBackImgView.hidden = YES;
        _bigTitleLabel = bigtitleLable;
        _bigTitleBackgImgView = bigTitleLabelBackImgView;
        
        
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:_panGes];
    }
    return self;
}
- (CGRect)preCalculateParameterWithSuperView:(UITableView *)view count:(NSUInteger)count{
    _letterMargin = 18;
    _selectLetterBack_WH = 18;
    _letterFont = [UIFont systemFontOfSize:15];
    CGFloat realHeight = count * _letterFont.lineHeight + (count-1)*_letterMargin;
    
    CGFloat width  = 32;
    CGFloat preheight = CGRectGetHeight(view.frame) - CGRectGetMinY(view.frame) - view.contentInset.top - view.contentInset.bottom - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - 80;
    
    if (realHeight > preheight) {
        realHeight = preheight;
        _letterMargin = (realHeight - count * _letterFont.lineHeight)/(count - 1);
    }
    
    CGRect rect = CGRectMake(CGRectGetMaxX(view.frame) - width, (view.frame.size.height-realHeight)/2, width, realHeight);
    
    return rect;
}

- (void)updateTitles:(NSArray *)titleArray{
    _panGes.cancelsTouchesInView = YES;
    _titles = nil;
    NSMutableDictionary *dic;
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (NSString *letter in titleArray) {
        dic = [NSMutableDictionary dictionary];
        [dic setObject:letter forKey:letter_key];
        [dic setObject:[[UIColor blackColor] colorWithAlphaComponent:0.4]forKey:letterColor_normal_key];
        [dataArray addObject:dic];
    }
    _titles = [dataArray copy];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (_titles.count == 0) {
        return;
    }
    CGPoint start = CGPointZero;
    NSUInteger count = _titles.count;
    float height = (CGRectGetHeight(rect) - (count-1)* _letterMargin)/ count;
    for (NSMutableDictionary *dic in _titles)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIColor *color = dic[letterColor_normal_key];
        CGRect arect = CGRectMake(start.x, start.y, rect.size.width, height);
        [dic[letter_key] drawInRect:arect withAttributes:@{
                                                          NSFontAttributeName : _letterFont,
                                                          NSForegroundColorAttributeName:color,
                                                          NSParagraphStyleAttributeName : paragraphStyle
                                                          }];
        [dic setObject:@(arect) forKey:letter_rect_key];
        
        start.y += height;
        start.y += _letterMargin;
    }
}

- (void)pan:(UIPanGestureRecognizer *)ges{
    switch (ges.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _selectedBgView.hidden = NO;
            [self handleEvent:ges];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self handleEvent:ges];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            _selectedBgView.hidden = YES;
//            [self handleEvent:ges];
            [self hiddenBigTitle];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            _selectedBgView.hidden = YES;
            [self hiddenBigTitle];
            break;
        }
        default:
            break;
    }
}

- (void)hiddenBigTitle{
    [UIView animateWithDuration:0.5 animations:^{
        _bigTitleBackgImgView.alpha=0;
    } completion:^(BOOL finished) {
        _bigTitleBackgImgView.hidden = YES;
        _bigTitleBackgImgView.alpha = 1;
    }];
}

- (void)handleEvent:(UIPanGestureRecognizer *)ges {
    CGPoint point = [ges locationInView:self];
    float height = CGRectGetHeight(self.frame) / _titles.count;
    float index = point.y / height;
    int indexM = index;
    if (_selectIndex != indexM) {
        _selectIndex = indexM;
        if (indexM < _titles.count && [_delegate respondsToSelector:@selector(sectionIndexBar:sectionDidSelected:title:)]) {
            NSDictionary *dic = [_titles objectAtIndex:indexM];
            NSString *letter= dic[letter_key];
            CGRect letterRect = [dic[letter_rect_key] CGRectValue];
            _selectedBgView.center = CGPointMake(CGRectGetMidX(letterRect), CGRectGetMidY(letterRect));
            CGRect superLetterRect = [self convertRect:letterRect toView:self.superview];
            _bigTitleBackgImgView.center = CGPointMake(CGRectGetMinX(superLetterRect) - CGRectGetWidth(_bigTitleBackgImgView.frame)/2 - bigTitleMarginWithLetter, CGRectGetMidY(superLetterRect));
            if (letter==nil || letter.length==0 || [letter isEqualToString:@" "])
            {
                return;
            }
            [_delegate sectionIndexBar:self sectionDidSelected:indexM title:letter];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
                [self.motorGenerator selectionChanged];
            }
            
            _bigTitleLabel.text = letter;
            _selectedBgView.text = letter;
            _bigTitleBackgImgView.hidden = NO;
            
        }
    }
    
    
}
#if __IPHONE_10_0
- (UISelectionFeedbackGenerator *)motorGenerator{
    if (_motorGenerator == nil) {
        _motorGenerator = [[UISelectionFeedbackGenerator alloc]init];
    }
    return _motorGenerator;
}
#else

#endif

@end

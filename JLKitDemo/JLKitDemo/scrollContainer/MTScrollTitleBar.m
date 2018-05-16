//
//  MTScrollTitleBar.m
//  MiTalk
//
//  Created by 王建龙 on 2017/9/7.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MTScrollTitleBar.h"
#import "MTScrollTitleButton.h"

NSString *const MTScrollTitleBar_CustomBtn = @"CustomBtn";
NSString *const MTScrollTitleBar_DefaultBtn = @"DefaultBtn";
NSString *const MTScrollTitleBar_BtnObject = @"BtnObject";
NSString *const MTScrollTitleBar_BtnType = @"BtnType";

#define MTScrollTitileBarContentLeftOrRightSpace 15

#define MTScrollTitileBar_title_tag 20170910


@interface MTScrollTitleBar ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray         *buttonOriginXArray;

@property (nonatomic, strong) NSMutableArray         *buttonWidthArray;

@property (nonatomic, strong) NSMutableArray         *buttonArray;

@property (nonatomic, assign) NSInteger              buttonSpace;

@property (nonatomic, assign) BOOL                   isAdjustTitleWidth;

@property (nonatomic, assign) BOOL                   hasCustomShadowView;

//内容宽度
@property (nonatomic, assign) CGFloat                contentWidth;

//背景线.默认是主题背景线
@property (nonatomic, strong) UIView                 *shadowView;

/**底部背景线*/
@property (nonatomic, strong) UIView                 *lineView;

@property (nonatomic, weak) UIButton                 *selectedTitleBtn;

@property (nonatomic, assign) NSUInteger             selectedIndex;

@property (nonatomic, strong) UIView                 *rightView;

@end

@implementation MTScrollTitleBar

#pragma mark - system

- (void)dealloc
{
    _contentScrollView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _selectedByTouchDown = NO;
        _autoScroller = YES;
        _lineViewHeight = 1;
        _firstBtnX = MTScrollTitileBarContentLeftOrRightSpace;
        [self _initializeSubViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame canScroll:(BOOL)scroll
{
    self = [self initWithFrame:frame];
    if (self) {
        self.autoScroller = scroll;
    }
    return self;
}

- (void)layoutSubviews
{
    self.contentScrollView.frame = self.bounds;
    
    [self _layoutTitlesForTopScrollerView:NO];
    if ((self.contentScrollView.contentSize.width <= self.contentScrollView.bounds.size.width) && self.contentScrollView.contentOffset.x != 0) {
        [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - reloadData

- (void)setDataSource:(id<MTScrollTitleBarDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (BOOL)reloadData
{
    _buttonOriginXArray = [[NSMutableArray alloc] init];
    _buttonWidthArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    
    //如果没有，就返回
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfTitleInScrollTitleBar:)]) {
        if ([self.dataSource numberOfTitleInScrollTitleBar:self] == 0) {
            return NO;
        }
    }
    
    //询问代理 按钮间距
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gapForEachItem:)]) {
        _buttonSpace = [self.dataSource gapForEachItem:self];
    }else{
        _buttonSpace = 25;
    }
    
    //是否自动调整字体宽度
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(enableAutoAdjustWidth:)]) {
        _isAdjustTitleWidth = [self.dataSource enableAutoAdjustWidth:self];
    }else{
        _isAdjustTitleWidth = YES;
    }
    
    [self _calculateContentWidth];
    [self _layoutTitlesForTopScrollerView:YES];
    return YES;
}


#pragma mark - button Click

//适用于类似于tabbar.的点击效果
- (void)selectNameButtonByTouchDown:(UIButton*)sender
{
    
    //如果是按下选中，则直接触发选中事件
    if (self.selectedByTouchDown == YES) {
        
        [self _selectNameButton:sender userClick:YES];
    }
    
}

- (void)selectNameButtonByTouchUpInside:(UIButton*)sender
{
    
    if (self.selectedByTouchDown == NO) {
        
        [self _selectNameButton:sender userClick:YES];
        _selectedIndex = [self _indexOfObject:sender];
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickItem:atIndex:)]) {
            [self.delegate clickItem:self atIndex:self.selectedIndex];
        }
    }
    
}

- (void)_selectNameButton:(UIButton *)sender userClick:(BOOL)userClick
{
    [self _setButtonStatet:sender userClick:userClick completion:nil];
    
}

#pragma mark - interface

- (void)updateTitleFromDataSource
{
    for (int i = 0 ; i<self.buttonArray.count; i++) {
        UIButton *btn = [self _objectAtIndex:i];
        NSString *title = [self.dataSource scrollTitleBar:self titleForIndex:i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateSelected];
        [self _calculateBtnWidthBtn:btn index:i isCustom:[self _isCustomObjectAtIndex:i] update:YES];
    }
    [self _layoutTitlesForTopScrollerView:NO];
    
}

- (void)scrollingToNextElement:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex scale:(CGFloat)scale
{
    CGRect fromRect = [self _lineViewRectForView:[self _objectAtIndex:fromIndex]];
    CGRect toRect = [self _lineViewRectForView:[self _objectAtIndex:toIndex]];
    
    CGFloat traction = fromRect.size.width * 0.3;
    CGFloat tractionThreshold = 0.2;
    
    CGPoint p1 = fromRect.origin;
    CGPoint p2 = CGPointMake(fromRect.origin.x + fromRect.size.width, fromRect.origin.y);
    //    CGPoint p3 = toRect.origin;
    CGPoint p4 = CGPointMake(toRect.origin.x + toRect.size.width, toRect.origin.y);
    
    //    CGFloat p1p4Xdist = p4.x - p1.x;
    CGFloat p2p4Xdist = p4.x - p2.x;
    CGFloat maxStretch = (p2p4Xdist) - 2 * traction;
    
    CGFloat finalX = fromRect.origin.x;
    CGFloat finalY = fromRect.origin.y;
    CGFloat finalW = fromRect.size.width;
    CGFloat finalH = fromRect.size.height;
    
    if (scale <= 0.5) {
        CGFloat offset = maxStretch * (scale * 2);
        CGFloat tractionOffset = traction;
        if (scale < tractionThreshold) {
            tractionOffset = traction * (scale / tractionThreshold);
        }
        
        finalW = fromRect.size.width + fabs(offset);
        finalX = p1.x + tractionOffset;
    }
    else {
        CGFloat offset =  maxStretch * ((1 - scale) * 2);
        CGFloat tractionOffset = traction;
        if (scale > 1 - tractionThreshold) {
            tractionOffset = traction * ((1 - scale) / tractionThreshold);
        }
        
        finalW = fromRect.size.width + offset;
        finalX = p4.x - tractionOffset - finalW;
    }
    
    CGRect finalRect = CGRectMake(finalX, finalY, finalW, finalH);
    //    NSLog(@"self.lineView.frame:%@",NSStringFromCGRect(finalRect));
    self.lineView.frame = finalRect;
}


- (void)setUpSelecteIndex:(NSUInteger)index
{
    
    NSAssert(index < [self.dataSource numberOfTitleInScrollTitleBar:self], @"设置的索引值超过了合理范围,请检测代码");
    _selectedIndex = index;
    
    UIButton *button;
    if (index < self.buttonArray.count) {
        
        button = [self.buttonArray[index] objectForKey:MTScrollTitleBar_BtnObject];
    }
    
    if (button) {
        [self _selectNameButton:button userClick:YES];
    }
    
}

- (void)showBadge:(BOOL)show atIndex:(NSInteger)index
{
    if (index >= 0 && index <self.buttonArray.count) {
        MTScrollTitleButton *btn = [self _objectAtIndex:index];
        btn.redDot.hidden = !show;
    }
}

- (void)showNumAlert:(BOOL)show content:(NSString *)content atIndex:(NSInteger)index
{
    if (index >= 0 && index <self.buttonArray.count) {
        
        MTScrollTitleButton *btn = [self _objectAtIndex:index];
        btn.alertLabelText = content;
        btn.alertLabel.hidden = !show;
    }
}

#pragma mark - setter UI

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (NSDictionary *dic in self.buttonArray) {
        UIButton *btn = dic[MTScrollTitleBar_BtnObject];
        [btn.titleLabel setFont:_titleFont];
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    for (NSDictionary *dic in self.buttonArray) {
        UIButton *btn = dic[MTScrollTitleBar_BtnObject];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    for (NSDictionary *dic in self.buttonArray) {
        UIButton *btn = dic[MTScrollTitleBar_BtnObject];
        [btn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
    }
}

- (void)setLineViewColor:(UIColor *)lineViewColor
{
    _lineViewColor = lineViewColor;
    [self.lineView setBackgroundColor:_lineViewColor];
}

- (void)setLineViewHeight:(CGFloat)lineViewHeight
{
    _lineViewHeight = lineViewHeight;
    CGFloat height = CGRectGetHeight(self.lineView.frame);
    CGFloat dy = (height - lineViewHeight)/2;
    self.lineView.frame = CGRectInset(self.lineView.frame, 0, dy);
}

#pragma mark - private func

- (void)_initializeSubViews
{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentScrollView.delegate = self;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.scrollsToTop = NO;
        [self addSubview:_contentScrollView];
    }
    
}


- (NSInteger)_indexOfObject:(UIButton *)sender
{
    for (NSDictionary *dic  in self.buttonArray) {
        UIButton *btn = [dic objectForKey:MTScrollTitleBar_BtnObject];
        if ([btn isEqual:sender]) {
            return [self.buttonArray indexOfObject:dic];
        }
    }
    return -1;
}

- (UIButton *)_objectAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.buttonArray.count) {
        return nil;
    }
    NSDictionary *dic = self.buttonArray[index];
    
    return [dic objectForKey:MTScrollTitleBar_BtnObject];
}

- (BOOL)_isCustomObjectAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.buttonArray.count) {
        return NO;
    }
    NSDictionary *dic = self.buttonArray[index];
    
    return [(NSString *)[dic objectForKey:MTScrollTitleBar_BtnType] isEqualToString:MTScrollTitleBar_CustomBtn];
}
//计算 更新 单个btn 的宽度.
- (CGFloat)_calculateBtnWidthBtn:(UIButton *)btn index:(NSUInteger)index isCustom:(BOOL)isCustom update:(BOOL)isUpdate
{
    
    if (_isAdjustTitleWidth) {
        
        if (isCustom) {
            CGFloat width = CGRectGetWidth(btn.frame);
            if (isUpdate) {
                [self.buttonWidthArray replaceObjectAtIndex:index withObject:@(ceilf(width))];
            }else{
                [self.buttonWidthArray addObject:@(ceilf(width))];
            }
            return width;
        }else{
            CGFloat buttonWidth = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(350, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : btn.titleLabel.font} context:nil].size.width;
            buttonWidth += 1;
            if (isUpdate) {
                [self.buttonWidthArray replaceObjectAtIndex:index withObject:@(ceilf(buttonWidth))];
            }else{
                [self.buttonWidthArray addObject:@(ceilf(buttonWidth))];
            }
            
            return ceilf(buttonWidth);
        }
    }else{
        CGFloat perBtnWidth = (CGRectGetWidth(self.contentScrollView.frame) - CGRectGetWidth(self.rightView.frame)) / [self.dataSource numberOfTitleInScrollTitleBar:self];
        
        if (isUpdate) {
            [self.buttonWidthArray replaceObjectAtIndex:index withObject:@(ceilf(perBtnWidth))];
        }else{
            [self.buttonWidthArray addObject:@(ceilf(perBtnWidth))];
        }
        return perBtnWidth;
    }
    
}

//计算内容总宽度(包含间距,按钮自身宽度)
- (void)_calculateContentWidth
{
    
    [self.buttonArray removeAllObjects];
    [self.buttonWidthArray removeAllObjects];
    
    NSInteger titleCount = [self.dataSource numberOfTitleInScrollTitleBar:self];
    _contentWidth = 0.0f;
    for (int i = 0; i < titleCount; i++) {
        UIButton *button;
        
        CGFloat btnWidth = 0.0f;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        //询问代理是否,自己自定义按钮.如果自定义按钮,将不会对按钮宽度做处理
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollTitleBar:titleButtonForIndex:)])
        {
            button = [self.dataSource scrollTitleBar:self titleButtonForIndex:i];
        }
        
        if (button == nil) {
            
            button = [MTScrollTitleButton buttonWithType:UIButtonTypeCustom];
            button.clipsToBounds = NO;
            [dic setObject:button forKey:MTScrollTitleBar_BtnObject];
            [dic setObject:MTScrollTitleBar_DefaultBtn forKey:MTScrollTitleBar_BtnType];
            
            UIFont *font = self.titleFont;
            UIFont *selectTitleFont = self.selectTitleFont;
            UIColor *titleColor = self.titleColor;
            UIColor *titleColorSelect = self.selectedTitleColor;
            if (!font) {
                font = [UIFont systemFontOfSize:15];
            }
            if (!selectTitleFont) {
                selectTitleFont = [UIFont systemFontOfSize:15];
            }
            if (!titleColor) {
                titleColor = [UIColor blackColor];
            }
            if (!titleColorSelect) {
                titleColorSelect = [UIColor colorWithRed:0xff/255.0 green:0x29/255.0 blue:0x66/255.0 alpha:1.0];
            }
            
            NSString *titile = nil;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollTitleBar:titleForIndex:)]) {
                titile = [self.dataSource scrollTitleBar:self titleForIndex:i];
            }
            if (titile) {
                [button setTitle:titile forState:UIControlStateNormal];
            }
            
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            [button setTitleColor:titleColorSelect forState:UIControlStateSelected];
            MTScrollTitleButton * btn = (MTScrollTitleButton *)button;
            btn.normalFont = font;
            btn.selectedFont = font;
            
            CGFloat buttonWidth = [self _calculateBtnWidthBtn:button index:i isCustom:NO update:NO];
            btnWidth += buttonWidth;
            
        }
        else {
            CGFloat buttonWidth = [self _calculateBtnWidthBtn:button index:i isCustom:YES update:NO];
            btnWidth += buttonWidth;
            
            
            [dic setObject:button forKey:MTScrollTitleBar_BtnObject];
            [dic setObject:MTScrollTitleBar_CustomBtn forKey:MTScrollTitleBar_BtnType];
        }
        
        
        _contentWidth += btnWidth;
        if (i < titleCount-1)
        {
            _contentWidth += _buttonSpace;
        }
        [_buttonArray addObject:dic];
        
        //只有当元素展示样式为默认时,才将rightview的宽度作为contentWidth的一部分
        if (self.elementDisplayStyle == MTScrollTitleBarElementStyleDefault) {
            if (self.rightView)
            {
                _contentWidth += CGRectGetWidth(self.rightView.bounds);
            }
        }
    }
}

//绘制button在容器视图中上
- (void)_layoutTitlesForTopScrollerView:(BOOL)reloadData
{
    
    if (reloadData) {
        self.selectedIndex = 0;
        [self _selectNameButton:[self _objectAtIndex:self.selectedIndex] userClick:NO];
    }
    for (UIView *view in self.contentScrollView.subviews) {
        [view removeFromSuperview];
    }
    [_buttonOriginXArray removeAllObjects];
    
    //是否已经更改了数据(增删,或者顺序改变)--暂时不做这个功能
    //    BOOL alreadyChangeDatas = YES;
    NSInteger titleCount = [self.dataSource numberOfTitleInScrollTitleBar:self];
    
    CGFloat xPos = 0.0;
    
    if (_isAdjustTitleWidth) {
        xPos = 5.0;
    }
    if (self.firstBtnX > 0) {
        xPos = self.firstBtnX;
    }
    
    if (_contentWidth <= self.contentScrollView.frame.size.width) {
        if (self.elementDisplayStyle == MTScrollTitleBarElementStyleCenter){
            xPos = (self.bounds.size.width-_contentWidth)/2;
        }
        
    }
    
    CGFloat unitAreaWidth = self.contentScrollView.frame.size.width/titleCount;
    if (self.buttonArray.count == 0) {
        return;
    }
    for (int i = 0; i < titleCount; i++)
    {
        NSDictionary *dic = self.buttonArray[i];
        UIButton *button = [dic objectForKey:MTScrollTitleBar_BtnObject];
        CGFloat btnW = [self.buttonWidthArray[i] floatValue];
        if (self.elementDisplayStyle == MTScrollTitleBarElementStyleAvarge)
        {
            
            xPos = unitAreaWidth * i + (unitAreaWidth - btnW)/2;
            button.frame = CGRectMake((int)xPos, 0, btnW, CGRectGetHeight(self.contentScrollView.frame));
            [self.buttonOriginXArray addObject:@(xPos)];
        }
        else
        {
            if ([(NSString *)[dic objectForKey:MTScrollTitleBar_BtnType] isEqualToString:MTScrollTitleBar_CustomBtn])
            {
                //自定义的按钮
                
                if (_isAdjustTitleWidth)
                {
                    button.frame = CGRectMake((int)xPos, 0, btnW, CGRectGetHeight(self.contentScrollView.frame));
                    [self.buttonOriginXArray addObject:@(xPos)];
                    xPos += btnW+_buttonSpace;
                }
                else
                {
                    CGFloat perBtnWidth = btnW;
                    [self.buttonOriginXArray addObject:@(xPos)];
                    xPos = perBtnWidth*i;
                    
                    button.frame = CGRectMake((int)xPos, 0, perBtnWidth, CGRectGetHeight(self.contentScrollView.frame));
                }
            }
            else
            {
                //自适应，根据文字长短设置btn大小
                if (_isAdjustTitleWidth)
                {
                    
                    button.frame = CGRectMake((int)xPos, 0, btnW, self.contentScrollView.frame.size.height);
                    [self.buttonOriginXArray addObject:@(xPos)];
                    
                    {
                        xPos += (btnW+_buttonSpace);
                    }
                    
                } else
                {
                    [self.buttonOriginXArray addObject:@(xPos)];
                    
                    button.frame = CGRectMake((int)xPos, 0, btnW, CGRectGetHeight(self.contentScrollView.frame));
                    xPos = btnW*i;
                }
                
            }
        }
        
        
        [button addTarget:self action:@selector(selectNameButtonByTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(selectNameButtonByTouchDown:) forControlEvents:UIControlEventTouchDown];
        
        [self.contentScrollView addSubview:button];
        
    }
    
    if (self.elementDisplayStyle == MTScrollTitleBarElementStyleDefault)
    {
        self.contentScrollView.contentSize = CGSizeMake(xPos - _buttonSpace+ MTScrollTitileBarContentLeftOrRightSpace, 0);
    }
    else
    {
        self.contentScrollView.contentSize = CGSizeMake(xPos + MTScrollTitileBarContentLeftOrRightSpace - _buttonSpace, 0);
        
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(shadowViewForScrollTitleBar:)]) {
        
        UIView *customShadowView = [self.dataSource shadowViewForScrollTitleBar:self];
        if (customShadowView != nil) {
            
            self.shadowView = customShadowView;
            self.shadowView.userInteractionEnabled = NO;
            [self.contentScrollView addSubview:self.shadowView];
            _hasCustomShadowView = YES;
        }
        
    }
    else{
        if ([_buttonOriginXArray count]>0) {
            if (self.selectedIndex < _buttonOriginXArray.count){
                
            }
            else {
                self.selectedIndex = 0;
            }
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_selectedTitleBtn.frame) - 20)/2.0 + CGRectGetMinX(_selectedTitleBtn.frame), CGRectGetHeight(_contentScrollView.frame) - 2*_lineViewHeight , 20, _lineViewHeight)];
            
            [lineView setUserInteractionEnabled:NO];
            if (self.lineViewColor) {
                [lineView setBackgroundColor:self.lineViewColor];
                
            }else {
                [lineView setBackgroundColor:[UIColor colorWithRed:0xff/255.0 green:0x29/255.0 blue:0x66/255.0 alpha:1.0]];
            }
            
            lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [_contentScrollView addSubview:lineView];
            self.lineView = lineView;
        }
    }
    //更新选中背景视图
    [self _updateShadowWithSelectedButton:self.selectedTitleBtn];
    
}

- (void)_setButtonStatet:(UIButton *)sender userClick:(BOOL)userClick completion:(void (^)(BOOL finish))setCompletion
{
    
    if ([self.selectedTitleBtn isEqual:sender]) {
        //避免重复点击.
        return;
    }
    
    [self.selectedTitleBtn setSelected:NO];
    self.selectedTitleBtn = sender;
    [self.selectedTitleBtn setSelected:YES];
    NSInteger index = [self _indexOfObject:sender];
    if (index >= 0 && index < [self.dataSource numberOfTitleInScrollTitleBar:self]) {
        [self _updateRightViewWithSelectIndex:index];
    }
    [self adjustScrollViewContentX:sender];
    
    //暂时 屏蔽一种动画效果
    //    if (!userClick) {
    //        [UIView animateWithDuration:0.4
    //                              delay:0
    //             usingSpringWithDamping:0.5
    //              initialSpringVelocity:0
    //                            options:UIViewAnimationOptionCurveLinear
    //                         animations:^{
    //
    //                             [self updateShadowWithSelectedButton:sender];
    //
    //                         }
    //                         completion:^(BOOL finished) {
    //
    //                             if (setCompletion) {
    //                                 setCompletion(YES);
    //                             }
    //                         }];
    //    }else{
    //        [self updateShadowWithSelectedButton:sender];
    //        if (setCompletion) {
    //            setCompletion(YES);
    //        }
    //    }
    [self _updateShadowWithSelectedButton:sender];
    if (setCompletion) {
        setCompletion(YES);
    }
}

- (void)_updateRightViewWithSelectIndex:(NSUInteger)index
{
    UIView *rightView;
    if ([_dataSource respondsToSelector:@selector(rightViewForScrollTitleBar:index:)]) {
        rightView = [_dataSource rightViewForScrollTitleBar:self index:index];
    }
    if (rightView) {
        [_rightView removeFromSuperview];
        _rightView = nil;
        _rightView = rightView;
        CGRect viewFrame = rightView.frame;
        viewFrame.origin = CGPointMake(CGRectGetWidth(self.bounds) - viewFrame.size.width, 0);
        viewFrame.size = CGSizeMake(viewFrame.size.width, CGRectGetHeight(self.bounds));
        rightView.frame = viewFrame;
        [self addSubview:rightView];
    } else {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
}

//更新选中背景视图
- (void)_updateShadowWithSelectedButton:(UIButton*)btn
{
    
    float shadowHeight = 0;
    float shadowY = 0;
    float shadowX = 0;
    float shadowWidth = 0;
    //如果是自定义的背景视图
    if (_hasCustomShadowView == YES) {
        
        shadowHeight = self.contentScrollView.frame.size.height;
        //按照默认选中的第一项按钮，设置背景视图宽度
        shadowWidth = btn.frame.size.width;
        shadowX = btn.frame.origin.x;
        
    }else{
        
        //默认滑动蓝条高度
        shadowHeight = 1.f;
        shadowY = self.contentScrollView.frame.size.height - shadowHeight;
        shadowWidth = btn.frame.size.width;
        shadowX = (btn.frame.size.width - shadowWidth)*0.5 + btn.frame.origin.x;
    }
    
    CGRect rect = self.shadowView.frame;
    rect.size.width = shadowWidth;
    rect.size.height = shadowHeight;
    rect.origin.y = shadowY;
    rect.origin.x = shadowX;
    //    self.shadowView.frame = rect;
    
    [self.lineView setFrame:CGRectMake((CGRectGetWidth(btn.frame) - 20)/2.0 + CGRectGetMinX(btn.frame), CGRectGetHeight(_contentScrollView.frame) -2*_lineViewHeight, 20, _lineViewHeight)];
}

- (CGRect)_lineViewRectForView:(UIView *)view
{
    float shadowHeight = 0;
    float shadowY = 0;
    float shadowX = 0;
    float shadowWidth = 0;
    //如果是自定义的背景视图
    if (_hasCustomShadowView == YES) {
        
        shadowHeight = self.contentScrollView.frame.size.height;
        //按照默认选中的第一项按钮，设置背景视图宽度
        shadowWidth = view.frame.size.width;
        shadowX = view.frame.origin.x;
        
    }else{
        
        shadowHeight = CGRectGetHeight(view.frame);
        shadowY = self.contentScrollView.frame.size.height - shadowHeight;
        shadowWidth = CGRectGetWidth(view.frame);
        shadowX = view.frame.origin.x;
    }
    
    return CGRectMake((CGRectGetWidth(view.frame) - 20)/2.0 + CGRectGetMinX(view.frame), CGRectGetHeight(_contentScrollView.frame) - 2*_lineViewHeight, 20, _lineViewHeight);
}


//点击按钮后scrollerview自适应 contentOffset
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    //判断是否支持自动滚动
    if (!self.autoScroller || (self.contentScrollView.contentSize.width <= self.contentScrollView.bounds.size.width)) {
        return;
    }
    
    //    [self oneAdjustStyle:sender];
    
    CGFloat maxOffsetX = _contentScrollView.contentSize.width - CGRectGetWidth(_contentScrollView.frame);
    CGFloat minOffsetX = 0;
    CGFloat offsetX = sender.center.x - CGRectGetWidth(_contentScrollView.frame)/2;
    if (offsetX < minOffsetX) {
        offsetX = minOffsetX;
    }
    if (offsetX > maxOffsetX){
        offsetX = maxOffsetX;
    }
    [_contentScrollView setContentOffset:CGPointMake(offsetX, _contentScrollView.contentOffset.y) animated:YES];
    
}

- (void)oneAdjustStyle:(UIView *)sender
{
    CGFloat originX = CGRectGetMinX(sender.frame);
    CGFloat width = CGRectGetWidth(sender.frame);
    
    UIView *firstView = [[_buttonArray objectAtIndex:0] objectForKey:MTScrollTitleBar_BtnObject];
    //    float firsrBtnx = [_buttonOriginXArray.firstObject floatValue];
    CGFloat firstBtnx = CGRectGetMinX(firstView.frame);
    // 如果点击到右边超出边界的的按钮时
    if (sender.frame.origin.x - self.contentScrollView.contentOffset.x > CGRectGetWidth(self.contentScrollView.frame)-(_buttonSpace+width)) {
        if (originX+CGRectGetWidth(self.contentScrollView.frame)>=self.contentScrollView.contentSize.width) {
            [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.contentSize.width-CGRectGetWidth(self.contentScrollView.frame), 0)  animated:YES];
        }else{
            [self.contentScrollView setContentOffset:CGPointMake(originX - 30, 0)  animated:YES];
        }
    }
    if (sender.frame.origin.x - self.contentScrollView.contentOffset.x < 5) {
        [self.contentScrollView setContentOffset:CGPointMake(originX - firstBtnx,0)  animated:YES];
    }
}

@end



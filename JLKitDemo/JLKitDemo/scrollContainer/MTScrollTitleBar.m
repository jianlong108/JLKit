//
//  MTScrollTitleBar.m
//  MiTalk
//
//  Created by 王建龙 on 2017/9/7.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MTScrollTitleBar.h"

NSString const* CustomBtn = @"CustomBtn";
NSString const* DefaultBtn = @"DefaultBtn";
NSString const* BtnObject = @"BtnObject";
NSString const* BtnType = @"BtnType";

#define MTScrollTitileBarContentLeftOrRightSpace 15

#define MTScrollTitileBar_title_tag 20170910


@interface MTScrollTitleBar ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray            *buttonOriginXArray;

@property (nonatomic, strong) NSMutableArray            *buttonWidthArray;

@property (nonatomic, strong) NSMutableArray            *buttonArray;

@property (nonatomic, assign) NSInteger                 buttonSpace;

@property (nonatomic,assign)  BOOL                      isAdjustTitleWidth;

@property (nonatomic,assign)  BOOL                      hasCustomShadowView;

//内容宽度
@property (nonatomic,assign)  CGFloat                   contentWidth;

@property (nonatomic, strong) UIFont                    *normalTitleFont;

@property (nonatomic, strong) UIColor                   *titleColor;

/*!
 @property
 @abstract 点击按钮选择名字ID
 */
@property (nonatomic, assign) NSInteger                 userSelectedChannelID;

//背景线.默认是粉红背景线
@property (nonatomic, strong) UIView                    *shadowView;
/**底部背景线*/
@property (nonatomic, strong) UIView                    *lineView;

@property (nonatomic, weak)   UIButton                  *selectedTitleBtn;

@property(nonatomic,assign,readwrite)NSUInteger selectedIndex;

@end

@implementation MTScrollTitleBar

- (void)dealloc
{
    _contentScrollView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectedByTouchDown = NO;
        self.autoScroller = YES;
//        _showLeftBorder = NO;
//        _showRightBorder = NO;
        
        self.firstBtnX = MTScrollTitileBarContentLeftOrRightSpace;
        [self initializeSubViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame canScroll:(BOOL)scroll
{
    self = [self initWithFrame:frame];
    if (self) {
        self.autoScroller = YES;
    }
    return self;
}
- (void)initializeSubViews
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
    
//    if (!_leftBorderView) {
//        _leftBorderView = [[UIImageView alloc] init];
//        [_leftBorderView setBackgroundColor:[UIColor clearColor]];
//        [_leftBorderView setUserInteractionEnabled:NO];
//        [_leftBorderView setImage:[[AHSkinManager sharedManager] imageWithImageKey:[AHUIImageNameHandle handleImageName:@"mask48_left"]]];
//        [_leftBorderView setHidden:YES];
//        [self addSubview:_leftBorderView];
//        
//    }
//    
//    if (!_rightBorderView) {
//        _rightBorderView = [[UIImageView alloc] init];
//        [_rightBorderView setBackgroundColor:[UIColor clearColor]];
//        [_rightBorderView setUserInteractionEnabled:NO];
//        [_rightBorderView setImage:[[AHSkinManager sharedManager] imageWithImageKey:[AHUIImageNameHandle handleImageName:@"mask48"]]];
//        [_rightBorderView setHidden:YES];
//        [self addSubview:_rightBorderView];
//    }
}
- (void)setDataSource:(id<MTScrollTitleBarDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}
- (void)reloadData {
    
//    _userSelectedChannelID = MTScrollTitileBar_title_tag;
//    _scrollViewSelectedChannelID = MTScrollTitileBar_title_tag;
    _buttonOriginXArray = [[NSMutableArray alloc] init];
    _buttonWidthArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    
    //如果没有，就返回
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfTitleInScrollTitleBar:)]) {
        if ([self.dataSource numberOfTitleInScrollTitleBar:self] == 0) {
            return;
        }
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gapForEachItem:)]) {
        _buttonSpace = [self.dataSource gapForEachItem:self];
    }else{
        _buttonSpace = 25;
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(enableAutoAdjustWidth:)]) {
        _isAdjustTitleWidth = [self.dataSource enableAutoAdjustWidth:self];
    }else{
        _isAdjustTitleWidth = YES;
    }
    
    [self calculateContentWidth];
    [self layoutTitlesForTopScrollerView:YES];
}

- (void)layoutSubviews
{
    self.contentScrollView.frame = self.bounds;
    
    [self layoutTitlesForTopScrollerView:NO];
    
}
- (CGFloat)calculateBtnWidthBtn:(UIButton *)btn isCustom:(BOOL)isCustom{
    
    if (!_isAdjustTitleWidth) {
        CGFloat perBtnWidth = CGRectGetWidth(self.contentScrollView.frame)/[self.dataSource numberOfTitleInScrollTitleBar:self];
        
        [self.buttonWidthArray addObject:@(perBtnWidth)];
        return perBtnWidth;
    }else{
        if (isCustom) {
            CGFloat width = CGRectGetWidth(btn.frame);
            [self.buttonWidthArray addObject:@(width)];
            return width;
        }else{
            CGFloat buttonWidth = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(350, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : btn.titleLabel.font} context:nil].size.width;
            [self.buttonWidthArray addObject:@(buttonWidth)];
            return buttonWidth;
        }
    }
    
}
- (void)calculateContentWidth{
    
    [self.buttonArray removeAllObjects];
    [self.buttonWidthArray removeAllObjects];
    
    NSInteger titleCount = [self.dataSource numberOfTitleInScrollTitleBar:self];
    _contentWidth = 0.0f;
    for (int i = 0; i < titleCount; i++) {
        UIButton *button;
        
        CGFloat btnWidth = 0.0f;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollTitleBar:titleButtonForIndex:)])
        {
            button = [self.dataSource scrollTitleBar:self titleButtonForIndex:i];
        }
        
        if (button == nil) {
            
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.clipsToBounds = NO;
            [dic setObject:button forKey:BtnObject];
            [dic setObject:DefaultBtn forKey:BtnType];
            
            UIFont *font = self.normalTitleFont;
            
            
//            if (self.boldFont) {
//                font = [[AHSkinManager sharedManager]boldfontForKey:AHtextsize02];
//            }
            if (font == nil) {
                font = [UIFont systemFontOfSize:13];
            }
            
            NSString *titile = nil;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollTitleBar:titleForIndex:)]) {
                titile = [self.dataSource scrollTitleBar:self titleForIndex:i];
            }
            if (titile) {
                [button setTitle:titile forState:UIControlStateNormal];
            }
            if (self.titleColor)
            {
                [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            }
            else
            {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            
            if (self.selectedTitleColor)
            {
                [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
            }
            else
            {
                [button setTitleColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:113/255.0 alpha:1.0] forState:UIControlStateSelected];
            }
            button.titleLabel.font = font;
//            button.normalFont = self.normalTitleFont;
//            button.selectedFont = self.selectedTitleFont;
            
            CGFloat buttonWidth = [self calculateBtnWidthBtn:button isCustom:NO];
            btnWidth += buttonWidth;
            
        }
        else {
            CGFloat buttonWidth = [self calculateBtnWidthBtn:button isCustom:YES];
            btnWidth += buttonWidth;
            
//            if (!_isAdjustTitleWidth) {
//                btnWidth = button.frame.size.width;
//                [self.buttonWidthArray addObject:@(button.frame.size.width)];
//            } else {
//                CGFloat perBtnWidth = CGRectGetWidth(self.contentScrollView.frame)/[self.dataSource numberOfTitleInScrollTitleBar:self];
//                btnWidth = perBtnWidth;
//                [self.buttonWidthArray addObject:@(perBtnWidth)];
//            }
            
            [dic setObject:button forKey:BtnObject];
            [dic setObject:CustomBtn forKey:BtnType];
        }
        
        
        _contentWidth += btnWidth;
        if (i < titleCount-1)
        {
            _contentWidth += _buttonSpace;
        }
        [_buttonArray addObject:dic];
        
        if (self.elementDisplayStyle == MTScrollTitleBarElementStyleDefault)
        {
//            if (self.rightView)
//            {
//                _contentWidth += self.rightView.frame.size.width;
//            }
        }
    }
}
//绘制button在容器视图中上
- (void)layoutTitlesForTopScrollerView:(BOOL)reloadData{
    
    if (reloadData) {
        self.selectedIndex = 0;
        self.selectedTitleBtn = [self objectAtIndex:0];
        [self.selectedTitleBtn setSelected:YES];
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
        UIButton *button = [dic objectForKey:BtnObject];
        CGFloat btnW = [self.buttonWidthArray[i] floatValue];
        if (self.elementDisplayStyle == MTScrollTitleBarElementStyleAvarge)
        {
            
            xPos = unitAreaWidth * i + (unitAreaWidth - btnW)/2;
            button.frame = CGRectMake((int)xPos, 0, btnW, CGRectGetHeight(self.contentScrollView.frame));
            [self.buttonOriginXArray addObject:@(xPos)];
        }
        else
        {
            if ([(NSString *)[dic objectForKey:BtnType] isEqualToString:CustomBtn])
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
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_selectedTitleBtn.frame) - 20)/2.0 + CGRectGetMinX(_selectedTitleBtn.frame), CGRectGetHeight(_contentScrollView.frame) - 1 - 1, 20, 1)];
            
            [lineView setUserInteractionEnabled:NO];
            if (self.lineViewColor) {
                [lineView setBackgroundColor:self.lineViewColor];
                
            }else {
                [lineView setBackgroundColor:[UIColor purpleColor]];
            }
            
            lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [_contentScrollView addSubview:lineView];
            self.lineView = lineView;
        }
    }
    //更新选中背景视图
    [self updateShadowWithSelectedButton:self.selectedTitleBtn];
    
}
- (void)setButtonStatet:(UIButton *)sender userClick:(BOOL)userClick completion:(void (^)(BOOL finish))setCompletion{
    
    if ([self.selectedTitleBtn isEqual:sender]) {
        //避免重复点击.
        return;
    }
    
    [self.selectedTitleBtn setSelected:NO];
    self.selectedTitleBtn = sender;
    [self.selectedTitleBtn setSelected:YES];
    
    [self adjustScrollViewContentX:sender];
    
    if (userClick) {
        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self updateShadowWithSelectedButton:sender];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if (setCompletion) {
                                 setCompletion(YES);
                             }
                         }];
    }else{
        [self updateShadowWithSelectedButton:sender];
        if (setCompletion) {
            setCompletion(YES);
        }
    }
    
}

//更新选中背景视图
- (void)updateShadowWithSelectedButton:(UIButton*)btn{
    
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
    
    [self.lineView setFrame:CGRectMake((CGRectGetWidth(btn.frame) - 20)/2.0 + CGRectGetMinX(btn.frame), CGRectGetHeight(_contentScrollView.frame) - 1 - 1, 20, 1)];
}

- (CGRect)lineViewRectForView:(UIView *)view{
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
    //shadowView rect
    CGRect rect = CGRectMake(shadowX, shadowY, shadowWidth, shadowHeight);
    
    return CGRectMake((CGRectGetWidth(view.frame) - 20)/2.0 + CGRectGetMinX(view.frame), CGRectGetHeight(_contentScrollView.frame) - 1 - 1, 20, 1);
}


//点击按钮后scrollerview自适应
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
    if (offsetX < 0) {
        offsetX = 0;
    }
    if (offsetX > maxOffsetX){
        offsetX = maxOffsetX;
    }
    [_contentScrollView setContentOffset:CGPointMake(offsetX, _contentScrollView.contentOffset.y) animated:YES];
    
    
    
}
- (void)oneAdjustStyle:(UIView *)sender{
    CGFloat originX = CGRectGetMinX(sender.frame);
    CGFloat width = CGRectGetWidth(sender.frame);
    
    UIView *firstView = [[_buttonArray objectAtIndex:0] objectForKey:BtnObject];
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



- (void)selectNameButtonByTouchDown:(UIButton*)sender{
    
    //如果是按下选中，则直接出发选中事件
    if (self.selectedByTouchDown == YES) {
        
        [self selectNameButton:sender userClick:YES];
    }
    
}

- (void)selectNameButtonByTouchUpInside:(UIButton*)sender{
    
    if (self.selectedByTouchDown == NO) {
        
        [self selectNameButton:sender userClick:YES];
    }
    
}

- (void)selectNameButton:(UIButton *)sender userClick:(BOOL)userClick
{
    [self setButtonStatet:sender userClick:userClick completion:^(BOOL finish) {
    }];
    
    if (userClick) {
        self.selectedIndex = [self indexOfObject:sender];
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickItem:atIndex:)]) {
            [self.delegate clickItem:self atIndex:self.selectedIndex];
        }
    }
    
}

#pragma mark - interface
- (void)updateTitleFromDataSource{
    for (int i = 0 ; i<self.buttonArray.count; i++) {
        UIButton *btn = [self objectAtIndex:i];
        NSString *title = [self.dataSource scrollTitleBar:self titleForIndex:i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateSelected];
        [self calculateBtnWidthBtn:btn isCustom:NO];
    }
    [self layoutTitlesForTopScrollerView:NO];
    
}
- (void)scrollingToNextElement:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex scale:(CGFloat)scale{
    CGRect fromRect = [self lineViewRectForView:[self objectAtIndex:fromIndex]];
    CGRect toRect = [self lineViewRectForView:[self objectAtIndex:toIndex]];
    
    CGFloat traction = fromRect.size.width * 0.3;
    CGFloat tractionThreshold = 0.2;
    
    CGPoint p1 = fromRect.origin;
    CGPoint p2 = CGPointMake(fromRect.origin.x + fromRect.size.width, fromRect.origin.y);
    CGPoint p3 = toRect.origin;
    CGPoint p4 = CGPointMake(toRect.origin.x + toRect.size.width, toRect.origin.y);
    
    CGFloat p1p4Xdist = p4.x - p1.x;
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

- (void)scrollingToNextElement:(BOOL)isNext scale:(CGFloat)scale index:(NSInteger)index{

//    NSLog(@"%d %ld %ld",isNext,index,_selectedIndex);
    NSUInteger count = [self.dataSource numberOfTitleInScrollTitleBar:self];
    
    CGRect fromRect = [self lineViewRectForView:[self selectedTitleBtn]];
    CGRect toRect;
    if (isNext) {
        NSUInteger nextIndex = self.selectedIndex + 1;
        if (nextIndex >= count) {
            return;
        }
        toRect = [self objectAtIndex:nextIndex].frame;
    }else{
        if (self.selectedIndex == 0) {
            return;
        }
        NSUInteger nextIndex = self.selectedIndex - 1;
        toRect = [self lineViewRectForView:[self objectAtIndex:nextIndex]];
    }
    
    NSInteger currentIndex = self.selectedIndex;
    if (self.selectedIndex != index) {
        self.selectedIndex = index;
        [self.selectedTitleBtn setSelected:NO];
        self.selectedTitleBtn = [self objectAtIndex:self.selectedIndex];
        [self.selectedTitleBtn setSelected:YES];
        [self adjustScrollViewContentX:self.selectedTitleBtn];
    }
//    NSUInteger nextIndex = 0;
//    if (isNext) {
//        if (currentIndex + 1 >= count) {
//            return;
//        }else{
//            nextIndex = currentIndex + 1;
//        }
//    }else{
//        if ((currentIndex - 1) < 0) {
//            return;
//        }else{
//            nextIndex = currentIndex - 1;
//            
//        }
//    }
    
//    nextView = [[self.buttonArray objectAtIndex:nextIndex]objectForKey:BtnObject];
//    UIButton *selectBtn = [[self.buttonArray objectAtIndex:currentIndex]objectForKey:BtnObject];
//    CGRect fromRect = [self lineViewRectForView:[self selectedTitleBtn]];
//    CGRect toRect = [self lineViewRectForView:nextView];
    CGFloat traction = fromRect.size.width * 0.3;
    CGFloat tractionThreshold = 0.2;
    
    CGPoint p1 = fromRect.origin;
    CGPoint p2 = CGPointMake(fromRect.origin.x + fromRect.size.width, fromRect.origin.y);
    CGPoint p3 = toRect.origin;
    CGPoint p4 = CGPointMake(toRect.origin.x + toRect.size.width, toRect.origin.y);
    
    CGFloat p1p4Xdist = p4.x - p1.x;
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

- (void)setUpSelecteIndex:(NSUInteger)index{
    
    NSAssert(index < [self.dataSource numberOfTitleInScrollTitleBar:self], @"设置的索引值超过了合理范围,请检测代码");
    _selectedIndex = index;
    
    UIButton *button;
    if (index < self.buttonArray.count) {
        
        button = [self.buttonArray[index] objectForKey:BtnObject];
    }
    
    if (button) {
        [self selectNameButton:button userClick:NO];
    }
    
}

#pragma mark - tool func

- (NSInteger)indexOfObject:(UIButton *)sender{
    for (NSDictionary *dic  in self.buttonArray) {
        UIButton *btn = [dic objectForKey:BtnObject];
        if ([btn isEqual:sender]) {
            return [self.buttonArray indexOfObject:dic];
        }
    }
    return -1;
}

- (UIButton *)objectAtIndex:(NSInteger)index{
    if (index < 0 || index >= self.buttonArray.count) {
        return nil;
    }
    NSDictionary *dic = self.buttonArray[index];
    
    return [dic objectForKey:BtnObject];
}

@end

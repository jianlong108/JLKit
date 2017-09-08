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

#define BUTTONID (sender.tag-MTScrollTitileBar_title_tag)

#define BUTTONSELECTEDID (_scrollViewSelectedChannelID - MTScrollTitileBar_title_tag)

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

/***/
@property (nonatomic, strong) UIColor                   *selectedTitleColor;

/*!
 @property
 @abstract 滑动列表选择名字ID
 */
@property (nonatomic, assign) NSInteger                 scrollViewSelectedChannelID;
/*!
 @property
 @abstract 点击按钮选择名字ID
 */
@property (nonatomic, assign) NSInteger                 userSelectedChannelID;

//背景线.默认是粉红背景线
@property (nonatomic, strong) UIView                    *shadowView;
/**底部背景线*/
@property (nonatomic, strong) UIView                    *lineView;
@property (nonatomic, strong) UIColor                   *lineViewColor;
@property (nonatomic, weak)   UIButton                  *selectedTitleBtn;

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
    
    _userSelectedChannelID = MTScrollTitileBar_title_tag;
    _scrollViewSelectedChannelID = MTScrollTitileBar_title_tag;
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
                [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            }
            button.titleLabel.font = font;
            //            button.normalFont = self.normalTitleFont;
            //            button.selectedFont = self.selectedTitleFont;
            
            
            //自适应，根据文字长短设置btn大小
            if (!_isAdjustTitleWidth) {
                CGFloat buttonWidth = [titile boundingRectWithSize:CGSizeMake(350, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width;
                btnWidth = buttonWidth;
                [self.buttonWidthArray addObject:@(buttonWidth)];
                
            } else {
                CGFloat perBtnWidth = CGRectGetWidth(self.contentScrollView.frame)/[self.dataSource numberOfTitleInScrollTitleBar:self];
                btnWidth = perBtnWidth;
                [self.buttonWidthArray addObject:@(perBtnWidth)];
            }
        }
        else {
            if (!_isAdjustTitleWidth) {
                btnWidth = button.frame.size.width;
                [self.buttonWidthArray addObject:@(button.frame.size.width)];
            } else {
                CGFloat perBtnWidth = CGRectGetWidth(self.contentScrollView.frame)/[self.dataSource numberOfTitleInScrollTitleBar:self];
                btnWidth = perBtnWidth;
                [self.buttonWidthArray addObject:@(perBtnWidth)];
            }
            
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
//绘制button在self上
- (void)layoutTitlesForTopScrollerView:(BOOL)reloadData{
    
    if (reloadData) {
        self.selectedIndex = 0;
    }
    for (UIView *vi in self.contentScrollView.subviews) {
        [vi removeFromSuperview];
    }
    [_buttonOriginXArray removeAllObjects];
    
    
    BOOL isRemoveBtn = YES;
    NSInteger titleCount = [self.dataSource numberOfTitleInScrollTitleBar:self];
    
    float xPos = 0.0;
    
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
                
                if (!_isAdjustTitleWidth)
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
                if (!_isAdjustTitleWidth)
                {
                    
                    button.frame = CGRectMake((int)xPos, 0, btnW, self.contentScrollView.frame.size.height);
                    [self.buttonOriginXArray addObject:@(xPos)];
                    
                    {
                        xPos += (btnW+_buttonSpace);
                    }
                    
                } else
                {
                    [self.buttonOriginXArray addObject:@(xPos)];
                    xPos = btnW*i;
                    
                    button.frame = CGRectMake((int)xPos, 0, btnW, CGRectGetHeight(self.contentScrollView.frame));
                }
                
            }
        }
        
        [button setTag:i + MTScrollTitileBar_title_tag];
        
        if (i == self.selectedIndex) {
            button.selected = YES;
            self.selectedIndex = self.selectedIndex;
        }
        
        if (self.selectedTitleBtn.tag == button.tag) {
            isRemoveBtn = NO;
            self.selectedTitleBtn = button;
            _userSelectedChannelID = button.tag;
            ((UIButton *)[self viewWithTag:MTScrollTitileBar_title_tag]).selected = NO;
            self.selectedIndex = i;
        }
        
        [button addTarget:self action:@selector(selectNameButtonByTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(selectNameButtonByTouchDown:) forControlEvents:UIControlEventTouchDown];
        
        [self.contentScrollView addSubview:button];
        
    }
    
    //    [self addSubview:self.rightView];
    
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
            if (self.selectedIndex < _buttonOriginXArray.count)
            {
                //                _shadowView = [[UIView alloc] initWithFrame:CGRectMake([[_buttonOriginXArray objectAtIndex:self.selectedIndex] floatValue]+7,0, 0, CGRectGetHeight(self.contentScrollView.frame))];
            }else {
                //                _shadowView = [[UIView alloc] initWithFrame:CGRectMake([[_buttonOriginXArray objectAtIndex:0] floatValue]+7,0, 0, CGRectGetHeight(self.contentScrollView.frame))];
                self.selectedIndex = 0;
            }
            //            [_shadowView setBackgroundColor:[UIColor clearColor]];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_selectedTitleBtn.frame) - 20)/2.0 + CGRectGetMinX(_selectedTitleBtn.frame), CGRectGetHeight(_contentScrollView.frame) - 1 - 1, 20, 1)];
            
            [lineView setUserInteractionEnabled:NO];
            if (self.lineViewColor) {
                [lineView setBackgroundColor:self.lineViewColor];
                
            }else {
                [lineView setBackgroundColor:[UIColor purpleColor]];
            }
            //            [_shadowView setBackgroundColor:[UIColor clearColor]];
            
            lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [_contentScrollView addSubview:lineView];
            //            _shadowView.userInteractionEnabled = NO;
            //            [self.contentScrollView addSubview:self.shadowView];
            self.lineView = lineView;
        }
    }
    //更新选中背景视图
    if ([_buttonOriginXArray count] > 0) {
        NSDictionary *dic;
        if (self.selectedIndex < _buttonArray.count)
        {
            dic = [_buttonArray objectAtIndex:self.selectedIndex];
        }else {
            dic = [_buttonArray objectAtIndex:0];
            self.selectedIndex = 0;
        }
        UIButton *btn = [dic objectForKey:BtnObject];
        [self updateShadowWithSelectedButton:btn];
    }
    if (!isRemoveBtn) {
        [self setButtonStatet:self.selectedTitleBtn completion:nil];
    }else{
        [self.contentScrollView setContentOffset:self.contentScrollView.contentOffset];
        if (_buttonArray.count > 0) {
            NSDictionary *dic;
            if (self.selectedIndex < _buttonArray.count)
            {
                dic = [_buttonArray objectAtIndex:self.selectedIndex];
                UIButton *btn = [dic objectForKey:BtnObject];
                self.selectedTitleBtn = btn;
                self.userSelectedChannelID = self.selectedTitleBtn.tag;
            }else {
                dic = [_buttonArray objectAtIndex:0];
                self.selectedIndex = 0;
                UIButton *btn = [dic objectForKey:BtnObject];
                self.selectedTitleBtn = btn;
                self.userSelectedChannelID = self.selectedTitleBtn.tag;
            }
            
        }
        
    }
    
}
- (void)setButtonStatet:(UIButton *)sender completion:(void (^)(BOOL finish))setCompletion{
    
    self.selectedTitleBtn = sender;
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:_userSelectedChannelID];
        [lastButton setSelected:NO];
        //赋值按钮ID
        _userSelectedChannelID = sender.tag;
        
        
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
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
        
    }
    //重复点击选中按钮
    else {
        
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

- (void)selecteIndex:(NSInteger)index
{
    
    self.selectedIndex = index;
    UIButton *button;
    if (index >= 0 && index < self.buttonArray.count) {
        
        button = [self.buttonArray[index] objectForKey:BtnObject];
    } else {
        return;
    }
    
    [self selectNameButton:button userhandel:NO];
    //    [self adjustScrollViewContentX:button];
    
}

//点击按钮后scrollerview自适应
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    //判断是否支持自动滚动
    if (!self.autoScroller || (self.contentScrollView.contentSize.width <= self.contentScrollView.bounds.size.width)) {
        return;
    }
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
    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONID] floatValue];
    float width = [[_buttonWidthArray objectAtIndex:BUTTONID] floatValue];
    
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
        
        [self selectNameButton:sender userhandel:YES];
    }
    
}

- (void)selectNameButtonByTouchUpInside:(UIButton*)sender{
    
    if (self.selectedByTouchDown == NO) {
        
        [self selectNameButton:sender userhandel:YES];
    }
    
}

- (void)selectNameButton:(UIButton *)sender userhandel:(BOOL)userHandel
{
    __weak typeof(self) weakself = self;
    [self setButtonStatet:sender completion:^(BOOL finish) {
        if (finish) {
            
            //赋值滑动列表选择频道ID
            weakself.scrollViewSelectedChannelID = sender.tag;
        }
        
    }];
    if (userHandel) {
        self.selectedIndex = _userSelectedChannelID - MTScrollTitileBar_title_tag;
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickItem:atIndex:)]) {
            [self.delegate clickItem:self atIndex:_userSelectedChannelID - MTScrollTitileBar_title_tag];
        }
    }
    
}
#pragma mark - interface

- (void)scrollingToNextElement:(BOOL)isNext scale:(CGFloat)scale{
    UIView *nextView;
    NSUInteger count = [self.dataSource numberOfTitleInScrollTitleBar:self];
    NSInteger currentIndex = self.selectedIndex;
    NSUInteger nextIndex = 0;
    if (isNext) {
        if (currentIndex + 1 >= count) {
            return;
        }else{
            nextIndex = currentIndex + 1;
        }
    }else{
        if ((currentIndex - 1) < 0) {
            return;
        }else{
            nextIndex = currentIndex - 1;
            
        }
    }
    
    nextView = [[self.buttonArray objectAtIndex:nextIndex]objectForKey:BtnObject];
    
    CGRect fromRect = [self lineViewRectForView:[self selectedTitleBtn]];
    CGRect toRect = [self lineViewRectForView:nextView];
    CGFloat traction = fromRect.size.width * 0.3;
    CGFloat tractionThreshold = 0.2;
    
    CGPoint p1 = fromRect.origin;
    CGPoint p2 = CGPointMake(fromRect.origin.x + fromRect.size.width, fromRect.origin.y);
    CGPoint p3 = toRect.origin;
    CGPoint p4 = CGPointMake(toRect.origin.x + toRect.size.width, toRect.origin.y);
    
    CGFloat p1p4Xdist = p4.x - p1.x;
    CGFloat p2p4Xdist = p4.x - p2.x;
    CGFloat maxStretch = p2p4Xdist - 2 * traction;
    
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
        
        finalW = fromRect.size.width + offset;
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
    self.lineView.frame = finalRect;
}

@end

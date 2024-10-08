//
//  JLMEenu.m
//  JLMenuDemo
//
//  Created by 王建龙 on 15/11/28.
//  Copyright © 2015年 AngelLL. All rights reserved.
//

#import "JLMenuView.h"

#define Margin 10.0f
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height

#pragma mark - 类:JLView -
@interface JLView : UIView

/**strokecolor*/
@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, strong) UIColor *pointFillColor;
/**箭头样式*/
@property (nonatomic, assign) PointDirection pointStyle;
/**箭头出现的边*/
@property (nonatomic, assign) PointAppearDirection pointAppearDirection;

/**圆角*/
@property (nonatomic, assign)  CGFloat cornerRadious;

@end


@implementation JLView

- (void)drawRect:(CGRect)rect
{
    CGFloat x = 0.0 ;//x为起始点的坐标x
    CGFloat y = 0.0;//y为起始点的坐标y
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGFloat locationX = w/6;
    if (self.pointStyle == PointDirectionLeft) {
        x = rect.origin.x + locationX;
        y = rect.origin.y + Margin;
    }else if (self.pointStyle == PointDirectionMiddle) {
        x = rect.origin.x + w/2 - Margin;
        y = rect.origin.y + Margin;
    }else {
        x = rect.origin.x + w -2*Margin-locationX;
        y = rect.origin.y + Margin;
    }
    
    CGFloat radious = self.cornerRadious;
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.pointAppearDirection == PointAppearDirectionTop) {
        
        CGContextMoveToPoint(context,x, y);//设置起点
        
        CGContextAddLineToPoint(context,x+Margin, y-Margin);//三角顶点
        
        CGContextAddLineToPoint(context,x+2*Margin, y);//终点
        
        
        CGContextAddLineToPoint(context,rect.origin.x + w - radious, y);
        
        CGContextAddArcToPoint(context, rect.origin.x + w, y, rect.origin.x + w, y + radious, radious);
        
        
        CGContextAddLineToPoint(context,rect.origin.x + w, rect.origin.y + h - radious);
        
        CGContextAddArcToPoint(context, rect.origin.x + w, rect.origin.y + h, rect.origin.x + w -radious, rect.origin.y + h, radious);
        
        CGContextAddLineToPoint(context,rect.origin.x + radious, rect.origin.y + h);
        
        CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + h, rect.origin.x , rect.origin.y + h - radious, radious);
        
        
        CGContextAddLineToPoint(context,rect.origin.x, y + Margin);
        
        CGContextAddArcToPoint(context, rect.origin.x, y, rect.origin.x + radious, y, radious);
        
    }else if (self.pointAppearDirection == PointAppearDirectionBottom) {
        
        CGContextMoveToPoint(context,rect.origin.x, radious);
        
        CGContextAddLineToPoint(context,rect.origin.x, rect.origin.y + h - Margin - radious);
        
        CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + h - Margin, rect.origin.x + radious, h - Margin, radious);
        
        CGContextAddLineToPoint(context,rect.origin.x + x, rect.origin.y + h - Margin);

        CGContextAddLineToPoint(context,x+Margin, h);//三角顶点

        CGContextAddLineToPoint(context,x+2*Margin, h - Margin);//终点

        CGContextAddLineToPoint(context,rect.origin.x + w - radious, h - Margin);

        CGContextAddArcToPoint(context, rect.origin.x + w, rect.origin.y + h - Margin, rect.origin.x + w, rect.origin.y + h - Margin - radious, radious);

        CGContextAddLineToPoint(context,rect.origin.x + w, rect.origin.y + radious);

        CGContextAddArcToPoint(context, rect.origin.x + w, rect.origin.y, rect.origin.x + w - radious, rect.origin.y, radious);

        CGContextAddLineToPoint(context,rect.origin.x + radious, rect.origin.y);

        CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x, rect.origin.y + radious, radious);
        
        
        
    }else{
        
    }
    
    
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [self.fillColor setFill]; //设置填充色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}

- (void)setPointFillColor:(UIColor *)pointFillColor{
    if (_pointFillColor != pointFillColor) {
        _pointFillColor = pointFillColor;
    }
    
}
- (UIColor *)fillColor{
    if (_pointFillColor) {
        return _pointFillColor;
    }
    return [UIColor blackColor];
}
@end

#pragma mark - 类:JLMenuViewCell -

@interface JLMenuViewCell : UICollectionViewCell
/**图像*/
@property (nonatomic, weak)UIImageView *iconView;
/**标题*/
@property (nonatomic, weak)UILabel *title;
@end
@implementation JLMenuViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super initWithCoder:aDecoder]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:image];
    image.contentMode = UIViewContentModeCenter;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    
    self.title = label;
    self.iconView = image;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.iconView.frame =CGRectMake(0, 0, w, h*2/3);
    self.title.frame =CGRectMake(0, CGRectGetMaxY(self.iconView.frame)-5, w, h/3);
}

@end
#pragma mark - 类:JLMenuView -
@interface JLMenuView ()
<
UITableViewDataSource,
UITableViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat rowHeight;
/**数据源*/
@property (nonatomic, strong)NSArray *dataArray;
/**对应显示的图片*/
@property (nonatomic, strong)NSArray *imageArray;
/**window载体*/
@property (nonatomic, weak)JLView *mainView;
/**视图类型*/
@property (nonatomic, assign)MenuViewType viewType;

/**箭头出现的位置*/
@property (nonatomic, assign) PointAppearDirection pointAppearDirection;

/**指向*/
@property (nonatomic, assign)PointDirection pointType;

/**内容颜色*/
@property (nonatomic, strong)UIColor *contentColor;

/**title颜色*/
@property (nonatomic, strong)UIColor *titleColor;

@end


@implementation JLMenuView

#pragma mark - interface -
- (void)show{
   UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
}
- (instancetype)initWithPoint:(CGPoint)point inView:(UIView *)fromeView {
    self = [super init];
    if (self) {
        self.origin = [self convertPoint:point fromView:fromeView];
    }
    return self;
}


- (void)creatSubviewsWithFrame:(CGPoint)origin{
    CGFloat x;
    CGFloat y;
    CGSize size = [self.dataSource contentViewSizeOfMenuView:self];
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat locationX = width/6;
    if (width<=0||height <=0) {
        return;
    }
    if (self.pointType == PointDirectionLeft) {
        x = origin.x - Margin - locationX;
        y = origin.y;
    }else if (self.pointType == PointDirectionMiddle){
        x = origin.x - width/2;
        y = origin.y;
    }else {
        x = origin.x - width + Margin + locationX;
        y = origin.y;
    }
    
    CGRect frame = CGRectZero;
    CGRect backViewFram = CGRectZero;
    switch (self.pointAppearDirection) {
        case PointAppearDirectionTop:
        {
            backViewFram = CGRectMake(x, y, width, height+ Margin);
            frame = CGRectMake(0+1, Margin+1, width - 2, height-2);
        }
            break;
        case PointAppearDirectionBottom:
        {
            backViewFram = CGRectMake(x, y-height - Margin, width, height+ Margin);
            frame = CGRectMake(0 + 1, 0+1, width-2, height-2);
        }
            break;
        default:
            break;
    }
    
    JLView *mainView = [[JLView alloc]initWithFrame:backViewFram];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pointFillColor = self.contentColor;
    mainView.pointStyle = self.pointType;
    mainView.pointAppearDirection = self.pointAppearDirection;
    mainView.strokeColor = [self strokeColor];
    mainView.cornerRadious = self.cornerRadious;
    
    if (self.viewType == MenuViewTypeTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        
        tableView.backgroundColor = self.contentColor;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.dataSource = self;
        tableView.delegate = self;
        [mainView addSubview:tableView];
        tableView.layer.cornerRadius = self.cornerRadious;
        tableView.bounces = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JLMenu"];
        self.tableView = tableView;
    }else if (self.viewType == MenuViewTypeCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        
        [collectionView registerClass:[JLMenuViewCell class] forCellWithReuseIdentifier:@"jlcollectionView"];
        collectionView.delegate = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.layer.cornerRadius = self.cornerRadious;
        collectionView.bounces = NO;
        [mainView addSubview:collectionView];
        self.collectionView = collectionView;
    }else if (self.viewType == MenuViewTypeCustomView){
        UIView *contentView = [self.dataSource menuViewContentView:self];
        contentView.layer.masksToBounds = YES;
        contentView.backgroundColor = [UIColor clearColor];
        contentView.frame = frame;
        [mainView addSubview:contentView];
    }
    [self addSubview:mainView];
    self.mainView = mainView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ceil([self.dataSource contentViewSizeOfMenuView:self].height / self.dataArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLMenu"];
    UIView *selectBackView  = [[UIView alloc]initWithFrame:cell.frame];
    selectBackView.backgroundColor = [UIColor orangeColor];
    cell.selectedBackgroundView = selectBackView;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = self.titleColor;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.dataArray[indexPath.row];
    //设置cell点击不变色
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.imageArray.count > indexPath.row && self.imageArray[indexPath.row] != nil) {
        cell.imageView.image = self.imageArray[indexPath.row];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(menuView:didSelectRowAtIndexPath:)]){
        [self.delegate menuView:self didSelectRowAtIndexPath:indexPath];
    }
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:YES animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self dismissWithCompletion];
}
#pragma mark - lazy -
- (NSArray *)imageArray{
    if (_imageArray == nil) {
        NSMutableArray *array =[NSMutableArray arrayWithCapacity:[self.dataSource numberOfSubmenusInCustomMenu:self]];
        if ([self.dataSource respondsToSelector:@selector(imageForSubmenuInCustomMenu:)]) {
            [array addObjectsFromArray:[self.dataSource imageForSubmenuInCustomMenu:self]];
        }
        
        _imageArray = [array copy];
    }
    return _imageArray;
}
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        
        NSMutableArray *array =[NSMutableArray arrayWithCapacity:[self.dataSource numberOfSubmenusInCustomMenu:self]];
        [array addObjectsFromArray:[self.dataSource titleForSubmenuInCustomMenu:self]];
        _dataArray = [array copy];
    }
    return _dataArray;
}
- (UIColor *)strokeColor{
    if ([self.dataSource respondsToSelector:@selector(menuViewStrokeColor:)]) {
        return [self.dataSource menuViewStrokeColor:self];
    }
    return [UIColor blackColor];
}
- (UIColor *)contentColor{
    if ([self.dataSource respondsToSelector:@selector(menuViewContentColor:)]) {
        return [self.dataSource menuViewContentColor:self];
    }
    return [UIColor blackColor];
}
- (UIColor *)titleColor{
    if ([self.dataSource respondsToSelector:@selector(menuViewTitleColor:)]) {
        return [self.dataSource menuViewContentColor:self];
    }
    return [UIColor whiteColor];
}
- (void)setDataSource:(id<JLMenuDataSource>)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self creatSubviewsWithFrame:self.origin];
    }
}

- (MenuViewType)viewType{
    if ([self.dataSource respondsToSelector:@selector(menuViewType:)]) {
        return [self.dataSource menuViewType:self];
    }
    return MenuViewTypeTableView;
}
- (PointAppearDirection)pointAppearDirection{
    if ([self.dataSource respondsToSelector:@selector(menuViewPointAppearanceDirection:)]) {
        return [self.dataSource menuViewPointAppearanceDirection:self];
    }
    return PointAppearDirectionTop;
}
- (PointDirection)pointType{
    if ([self.dataSource respondsToSelector:@selector(menuViewDirection:)]) {
        return [self.dataSource menuViewDirection:self];
    }
    return PointDirectionMiddle;
}
#pragma mark - dismiss -
- (void)dismissWithCompletion{
    if (self.superview) {
        
        [self removeFromSuperview];
        if ([self.delegate  respondsToSelector:@selector(didCloseMenu:)]) {
            [self.delegate didCloseMenu:self];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissWithCompletion];
}
#pragma mark - UICollectionView -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JLMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"jlcollectionView" forIndexPath:indexPath];
    cell.backgroundColor = self.contentColor;
    NSLog(@"%lu",indexPath.row);
    if (self.imageArray.count > indexPath.row && self.imageArray.count <= self.dataArray.count) {
        if (self.imageArray[indexPath.row]) {
            [cell.iconView setImage:self.imageArray[indexPath.row]];
        }
    }
    
    if (self.dataArray[indexPath.row]) {
        [cell.title setText:self.dataArray[indexPath.row]];
    }
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectRowAtIndexPath:)]) {
        [self.delegate menuView:self didSelectRowAtIndexPath:indexPath];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self dismissWithCompletion];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0.5, 0, 0.5);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [self.dataSource contentViewSizeOfMenuView:self].width;
    return CGSizeMake(((width - 1.5)/2), ((width - 1.5)/2));
}
@end



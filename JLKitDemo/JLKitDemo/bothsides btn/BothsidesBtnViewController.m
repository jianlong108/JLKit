//
//  UserViewController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "BothsidesBtnViewController.h"
#import "JLBothSidesBtn.h"
#import "JLMenuView.h"

@interface BothsidesBtnViewController ()
<
JLMenuDelegate,
JLMenuDataSource
>
/**双面button*/
@property (nonatomic, strong)JLBothSidesBtn *bothSidesView;
@end

@implementation BothsidesBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn  =[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    [btn setTitle:@"点击切换按钮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _bothSidesView  =[[JLBothSidesBtn alloc]initWithFrame:CGRectMake(100, 100, 66, 66)];
    _bothSidesView.center = self.view.center;
    [self.view addSubview:_bothSidesView];
    _bothSidesView.autoTransition = NO;
    [_bothSidesView.positiveBtn addTarget:self action:@selector(dbtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_bothSidesView.oppositeBtn addTarget:self action:@selector(dbtn2) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dbtn1:(UIButton *)sender{
    NSLog(@"positiveBtn");
    CGPoint point = CGPointMake(sender.center.x, CGRectGetMinY(sender.frame));
    JLMenuView *menuView = [[JLMenuView alloc]initWithPoint:point inView:sender];
    menuView.delegate = self;
    menuView.dataSource = self;
    [menuView show];
}
-(void)dbtn2{
    NSLog(@"oppositeBtn");
}
-(void)switchBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_bothSidesView transitionView];
}
#pragma mark - JLMenuViewDelegate
- (NSUInteger)numberOfSubmenusInCustomMenu:(JLMenuView *)menuView{
    return 6;
}
- (NSArray<NSString *> *)titleForSubmenuInCustomMenu:(JLMenuView *)menuView{
    return @[@"1314 一生一世",@"520 我爱你",@"188 要抱抱",@"66 一切顺利",@"10 十全十美",@"1 一心一意"];
}

- (CGSize)contentViewSizeOfMenuView:(JLMenuView *)menuView{
    return CGSizeMake(300, 40);
}
- (PointDirection)menuViewDirection:(JLMenuView *)menuView{
    return PointDirectionMiddle;
}
- (PointAppearDirection)menuViewPointAppearanceDirection:(JLMenuView *)menuView{
    return PointAppearDirectionBottom;
}
- (MenuViewType)menuViewType:(JLMenuView *)menuView{
    return MenuViewTypeCustomView;
}
- (UIView *)menuViewContentView:(JLMenuView *)menuView{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"消费时优先消耗银钻哦~";
    return label;
}
@end

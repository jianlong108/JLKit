//
//  Test_MenuViewController.m
//  JLKitDemo
//
//  Created by 王建龙 on 2017/11/9.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "Test_MenuViewController.h"
#import "JLMenuView.h"

@interface Test_MenuViewController ()
<
    JLMenuDelegate,
    JLMenuDataSource
>

@end

@implementation Test_MenuViewController

- (void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(80,80 ,200,89);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"显示菜单view" forState: UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [btn addTarget:self action:@selector(testbtnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (void)testbtnclick:(UIButton *)sender{
    CGPoint point = CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame));
    JLMenuView *menuView = [[JLMenuView alloc]initWithPoint:point inView:sender];
    menuView.delegate = self;
    menuView.dataSource = self;
    [menuView show];
}
#pragma mark - JLMenuViewDelegate
- (NSUInteger)numberOfSubmenusInCustomMenu:(JLMenuView *)menuView{
    return 6;
}
- (NSArray<NSString *> *)titleForSubmenuInCustomMenu:(JLMenuView *)menuView{
    return @[@"1314 一生一世",@"520 我爱你",@"188 要抱抱",@"66 一切顺利",@"10 十全十美",@"1 一心一意"];
}

- (CGSize)contentViewSizeOfMenuView:(JLMenuView *)menuView{
    CGSize size = [@"消费时优先消耗银钻哦~" boundingRectWithSize:CGSizeMake(MAXFLOAT, [UIFont systemFontOfSize:14].lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return CGSizeMake(size.width + 20, size.height + 20);
}
- (UIColor *)menuViewStrokeColor:(JLMenuView *)menuView{
    return [UIColor clearColor];
}
- (UIColor *)menuViewContentColor:(JLMenuView *)menuView{
    return [[UIColor blackColor] colorWithAlphaComponent:0.4];
}
- (PointDirection)menuViewDirection:(JLMenuView *)menuView{
    return PointDirectionMiddle;
}
- (PointAppearDirection)menuViewPointAppearanceDirection:(JLMenuView *)menuView{
    return PointAppearDirectionTop;
}
- (MenuViewType)menuViewType:(JLMenuView *)menuView{
    return MenuViewTypeCustomView;
}
- (UIView *)menuViewContentView:(JLMenuView *)menuView{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.textColor = [UIColor whiteColor];
    label.text = @"消费时优先消耗银钻哦~";
    return label;
}

@end

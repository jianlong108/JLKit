//
//  UserViewController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "BothsidesBtnViewController.h"
#import "JLBothSidesBtn.h"

@interface BothsidesBtnViewController ()
/**双面button*/
@property (nonatomic, strong)JLBothSidesBtn *bothSidesView;
@end

@implementation BothsidesBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn  =[[UIButton alloc]initWithFrame:CGRectMake(100, 300, 200, 100)];
    [btn setTitle:@"点击切换按钮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _bothSidesView  =[[JLBothSidesBtn alloc]initWithFrame:CGRectMake(100, 100, 44, 44)];
    [self.view addSubview:_bothSidesView];
    _bothSidesView.autoTransition = NO;
    [_bothSidesView.positiveBtn addTarget:self action:@selector(dbtn1) forControlEvents:UIControlEventTouchUpInside];
    [_bothSidesView.oppositeBtn addTarget:self action:@selector(dbtn2) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dbtn1{
    NSLog(@"positiveBtn");
    
}
-(void)dbtn2{
    NSLog(@"oppositeBtn");
}
-(void)switchBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_bothSidesView transitionView];
}



@end

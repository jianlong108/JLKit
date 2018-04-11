//
//  UserViewController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "BothsidesBtnViewController.h"
#import "TwoFaceButton.h"
#import "MultifunctionBtn.h"

@interface BothsidesBtnViewController ()

/**双面button*/
@property (nonatomic, strong)TwoFaceButton *bothSidesView;
@end

@implementation BothsidesBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn  =[[UIButton alloc]initWithFrame:CGRectMake(100, 88, 200, 44)];
    [btn setTitle:@"点击切换按钮" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    MultifunctionBtn *btn1  =[[MultifunctionBtn alloc]initWithFrame:CGRectMake(100, 144, 200, 44)];
    
    [btn1 setTitle:@"图左字右" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"nav_crown"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    MultifunctionBtn *btn2  =[[MultifunctionBtn alloc]initWithFrame:CGRectMake(100, 198, 200, 44)];
    
    btn2.btnStyle = MultifunctionBtnStyleTitleLeft;
    [btn2 setTitle:@"图右字左" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"nav_crown"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    MultifunctionBtn *btn3  =[[MultifunctionBtn alloc]initWithFrame:CGRectMake(100, 252, 200, 88)];
    
    btn3.btnStyle = MultifunctionBtnStyleTitleTop;
    [btn3 setTitle:@"图下字上" forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"nav_crown"] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    MultifunctionBtn *btn4  =[[MultifunctionBtn alloc]initWithFrame:CGRectMake(100, 350, 200, 88)];
    
    btn4.btnStyle = MultifunctionBtnStyleTitleBottom;
    [btn4 setTitle:@"图右字左" forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"nav_crown"] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    
    MultifunctionBtn *btn5  =[[MultifunctionBtn alloc]initWithFrame:CGRectMake(100, 450, 200, 88)];
    
    btn5.btnStyle = MultifunctionBtnStyleTitleTop;
    [btn5 setTitle:@"主副标题" forState:UIControlStateNormal];
    [btn5.subTitleLabel setText:@"副标题"];
    [self.view addSubview:btn5];
    
    
    [btn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _bothSidesView  =[[TwoFaceButton alloc]initWithFrame:CGRectMake(0, 400, 66, 66)];
    _bothSidesView.center = self.view.center;
//    [self.view addSubview:_bothSidesView];
    _bothSidesView.autoTransition = NO;
    [_bothSidesView.positiveBtn addTarget:self action:@selector(dbtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_bothSidesView.oppositeBtn addTarget:self action:@selector(dbtn2) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dbtn1:(UIButton *)sender{
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

//
//  UserViewController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "UserViewController.h"
#import "JLBothSidesBtn.h"

@interface UserViewController ()
/**双面button*/
@property (nonatomic, strong)JLBothSidesBtn *bothSidesView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bothSidesView  =[[JLBothSidesBtn alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_bothSidesView];
    _bothSidesView.autoTransition = NO;
    
    // Do any additional setup after loading the view.
    
    [_bothSidesView.positiveBtn addTarget:self action:@selector(dbtn1) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_bothSidesView.oppositeBtn addTarget:self action:@selector(dbtn2) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)dbtn1{
    NSLog(@"positiveBtn");
    
}
-(void)dbtn2{
    NSLog(@"oppositeBtn");
}
-(void)dbtn3{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_bothSidesView transitionView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

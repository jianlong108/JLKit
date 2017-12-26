//
//  LoginViewController.m
//  JLKitDemo
//
//  Created by 王建龙 on 2017/11/16.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "LoginViewController.h"
#import "JLTextFiled.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    JLTextFiled *nameTxtFiled = [[JLTextFiled alloc]initWithFrame:CGRectMake(50, 200, 200, 44)];
    nameTxtFiled.textOriginOffset = UIOffsetMake(20, 0);
    
    nameTxtFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTxtFiled.backgroundColor = [UIColor lightGrayColor];
    
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor orangeColor];
    nameTxtFiled.leftView = leftView;
    
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [UIColor blueColor];
    nameTxtFiled.rightView = rightView;
    
    nameTxtFiled.leftViewMode = UITextFieldViewModeAlways;
    nameTxtFiled.placeholder = @"请输入用户名";
    [self.view addSubview:nameTxtFiled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

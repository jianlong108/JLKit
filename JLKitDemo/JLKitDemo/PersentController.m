//
//  PersentController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "PersentController.h"
#import "JLPresentationController.h"
#import "ViewController.h"

@interface PersentController ()<UIViewControllerTransitioningDelegate>

@end

@implementation PersentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ViewController *presentVC = [[ViewController alloc] init];
    // 设置 动画样式
//    presentVC.modalPresentationStyle = UIModalPresentationCustom;
    //presentVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 此对象要实现 UIViewControllerTransitioningDelegate 协议
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:presentVC];
//
    nav.modalPresentationStyle = UIModalPresentationCustom;
    nav.transitioningDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
}

/**
 presentedViewController     将要跳转到的目标控制器
 presentingViewController    跳转前的原控制器
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    

    return [[JLPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}


@end



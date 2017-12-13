//
//  TempViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/9/25.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TempViewController.h"

@interface TempViewController ()

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIViewController *viewvc = [[UIViewController alloc]init];
//    viewvc.view.backgroundColor = [UIColor redColor];
//
//    UIViewController *viewvc1 = [[UIViewController alloc]init];
//    viewvc1.view.backgroundColor = [UIColor orangeColor];
//    [self setViewControllers:@[viewvc,viewvc1]];
    NSString *str = @"a";
    [self tempStr:str];
    NSLog(@"%@",str);
    int a = 1;
    [self tempInt:&a];
    NSLog(@"%d",a);
}

- (void)tempStr:(NSString *)str{
    str = @"赋值";
}
- (void)tempInt:(int *)a{
    *a = 9;
}

@end

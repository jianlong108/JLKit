//
//  infinitLoopViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/9/3.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "infinitLoopViewController.h"
#import "InfiniteLoopView.h"

@interface infinitLoopViewController ()

@end

@implementation infinitLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    InfiniteLoopView *loop = [[InfiniteLoopView alloc] initWithFrame:CGRectMake(0, 100, 300, 200) scrollDuration:3.f];
    loop.backgroundColor = [UIColor orangeColor];
   
    loop.imageURLStrings = @[@"1.jpg", @"2.jpg", @"3.jpg",@"4.jpg",@"5.jpg"];
    loop.clickAction = ^(NSInteger index) {
        NSLog(@"curIndex: %ld", index);
    };
    
    [self.view addSubview:loop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

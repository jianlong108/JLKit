//
//  MasonryDemoViewController.m
//  JLKitDemo
//
//  Created by JL on 2023/4/2.
//  Copyright © 2023 JL. All rights reserved.
//

#import "MasonryDemoViewController.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MasonryDemoViewController ()
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) MASConstraint *greenTopConstraint;
@end

@implementation MasonryDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIButton *red = [UIButton buttonWithType:UIButtonTypeCustom];
    [red setTitle:@"点击让绿色远离" forState:UIControlStateNormal];
    [red setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [red addTarget:self action:@selector(redClick) forControlEvents:UIControlEventTouchUpInside];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200,200));
        make.top.equalTo(self.view).offset(100);
        make.leading.offset(50);
    }];
    
    
    UIButton *yellow = [UIButton buttonWithType:UIButtonTypeCustom];
    [yellow setTitle:@"点击让绿色靠近" forState:UIControlStateNormal];
    [yellow setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [yellow addTarget:self action:@selector(yellowClick) forControlEvents:UIControlEventTouchUpInside];

    yellow.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellow];
    [yellow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200,200));
        make.top.equalTo(red.mas_bottom).offset(50);
        make.leading.equalTo(red);
    }];
    self.yellowView = yellow;
    
    UIView *green = [UIView new];
    green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:green];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100,100));
        self.greenTopConstraint = make.top.equalTo(yellow.mas_bottom).offset(50).priorityHigh();
        make.top.equalTo(red.mas_bottom).offset(50).priorityMedium();
        make.leading.equalTo(yellow.mas_trailing);
    }];
    
}

- (void)redClick
{
    [self.greenTopConstraint activate];
}
- (void)yellowClick
{
    [self.greenTopConstraint deactivate];
}

@end


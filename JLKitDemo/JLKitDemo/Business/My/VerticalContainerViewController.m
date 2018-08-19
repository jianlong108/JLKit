//
//  VerticalContainerViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/8/14.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "VerticalContainerViewController.h"
#import "JLVerticalScrollController.h"

@interface VerticalContainerViewController ()<
    JLVerticalScrollControllerDelegate,
    JLVerticalScrollControllerDataSource
>

@end

@implementation VerticalContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JLVerticalScrollController *controller = [[JLVerticalScrollController alloc]init];
    controller.delegate = self;
    controller.dataSource = self;
    controller.view.frame = self.view.bounds;
    [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
}

- (NSInteger)numberOfTitleInScrollNavigationController:(JLVerticalScrollController *)scrollNavigationController
{
    return 3;
}

- (UIViewController<JLScrollNavigationChildControllerProtocol> *)scrollNavigationController:(JLVerticalScrollController *)scrollNavigationController childViewControllerForIndex:(NSInteger)index
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = [NSString stringWithFormat:@"%ld",index];
    vc.view.userInteractionEnabled = NO;
    [vc.view addSubview:label];
    return vc;
}


- (BOOL)backRecognizerResolvedBySystem
{
    return NO;
}
- (XMPanMoveDirection)supportNavigationBackDirection
{
    return kXMPanMoveDirectionHorzontal;
}


@end

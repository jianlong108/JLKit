//
//  ContainerDemoViewController.m
//  JLKitDemo
//
//  Created by JL on 2023/4/2.
//  Copyright © 2023 JL. All rights reserved.
//

#import "ContainerDemoViewController.h"
#import "JLScrollNavigationController.h"

@interface ContainerDemoViewController ()<
    JLScrollNavigationControllerDelegate,
    JLScrollNavigationControllerDataSource
>

@end

@implementation ContainerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JLScrollNavigationController *controller = [[JLScrollNavigationController alloc]init];
    
    controller.scrollNavigationDataSource = self;
    controller.scrollNavigationDelegate = self;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];

    [self.view addSubview:controller.view];
    

    
}

- (NSInteger)numberOfTitleInScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    return 2;
}

- (UIViewController<JLScrollNavigationChildControllerProtocol> *)scrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
                                                                   childViewControllerForIndex:(NSInteger)index
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
    return (UIViewController<JLScrollNavigationChildControllerProtocol> *)vc;
}

- (NSString *)scrollNavigationController:(JLScrollNavigationController *)scrollNavigationController controllerTitleWithIndex:(NSUInteger)index
{
    if (index == 0) {
        return @"推荐";
    }
    return @"热门";
}

@end

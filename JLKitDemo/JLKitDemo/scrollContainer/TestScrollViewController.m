//
//  TestScrollViewController.m
//  JLKitDemo
//
//  Created by 王建龙 on 2017/9/8.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TestScrollViewController.h"
#import "MTScrollNavgationController.h"
#import "UIViewController+JL.h"

@interface TestScrollViewController ()<
MTScrollNavigationViewControllerDelegate,
MTScrollNavigationViewControllerDataSource
>

/**<#message#>*/
@property (nonatomic, strong) MTScrollContainerViewController *scrollContentViewController;

@end


@implementation TestScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // Do any additional setup after loading the view.
        _scrollContentViewController = [[MTScrollContainerViewController alloc]init];
        _scrollContentViewController.scrollNavigationDelegate = self;
        _scrollContentViewController.scrollNavigationDataSource = self;
    
        [self.view addSubview:_scrollContentViewController.view];
    
        [self addChildViewController:_scrollContentViewController];
        [_scrollContentViewController didMoveToParentViewController:self];
    
    
        _scrollContentViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollContentViewController.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfTitleInScrollNavigationViewController:(MTScrollContainerViewController *)scrollNavigationVC{
    return 10;
}

- (NSString*)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC titleForIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"测试%ld",index];
}
- (UIViewController *)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC childViewControllerForIndex:(NSInteger)index{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    
    return vc;
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

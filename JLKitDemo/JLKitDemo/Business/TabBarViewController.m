//
//  TabBarViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/26.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TabBarViewController.h"
#import "XMNavigationController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "JLNavigationController.h"
#import "JLFoldAnimationer.h"
#import "JLHorizontalPanInteraction.h"
#import "HomeContainerController.h"
#import "PrincipleViewController.h"
#import <libkern/OSAtomic.h>
#import <dlfcn.h>

@interface TabBarViewController ()<
    UITabBarControllerDelegate
>
{
    JLFoldAnimationer *_animationController;
    JLHorizontalPanInteraction *_panInteractionGesture;
}

@end

@implementation TabBarViewController

static OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;

//定义符号结构体

typedef struct {
    void * pc;
    void * next;
} KBNode;

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop) {
    static uint64_t N;
    if (start == stop || *start) return;
    for (uint32_t *x = start; x < stop; x++) {
        *x = ++N;
    }
    printf("jl hook INIT Count: %llu \n", N);
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {

//  if (!*guard) return;
    void *PC = __builtin_return_address(0);
//    Dl_info info;
//    dladdr(PC, &info);
//    NSLog(@"%s\n,\n",info.dli_sname);
    KBNode *node = malloc(sizeof(KBNode));
    *node = (KBNode){PC,NULL};//赋值，强转，next表示下个节点的地址
    OSAtomicEnqueue(&symbolList, node, offsetof(KBNode, next));//原子列表写入方法，并把下个节点的地址写入。
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //定义数组
    NSMutableArray<NSString *> * symbleNames = [NSMutableArray array];
    while (YES) {
        KBNode *node = OSAtomicDequeue(&symbolList, offsetof(KBNode, next));
        if (node == NULL) {
            break;//没有的话结束
        }
        Dl_info info;
        dladdr(node->pc, &info);
//        printf("%s\n",info.dli_sname);
        NSString * name = @(info.dli_sname);//转字符串
        BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
        NSString * symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
        [symbleNames addObject:symbolName];
        
    }
    //添加
    NSEnumerator * em = [symbleNames reverseObjectEnumerator];
    NSMutableArray * funcs = [NSMutableArray arrayWithCapacity:symbleNames.count];
    NSString * name;
    while (name = [em nextObject]) {
        if (![funcs containsObject:name]) {//数组没有name
            [funcs addObject:name];
        }
    }
    //去掉自己！
    [funcs removeObject:[NSString stringWithFormat:@"%s",__func__]];
    //写入文件
    //1.编程字符串
    NSString * funcStr = [funcs componentsJoinedByString:@"\n"];
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.order"];
    NSData * file = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:file attributes:nil];
    NSLog(@"jl hook %@",filePath);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // create the interaction / animation controllers
//    _panInteractionGesture = [JLHorizontalPanInteraction new];
//    _animationController = [JLFoldAnimationer new];
//    _animationController.folders = 3;
    
    // observe changes in the currently presented view controller
//    [self addObserver:self
//           forKeyPath:@"selectedViewController"
//              options:NSKeyValueObservingOptionNew
//              context:nil];
    
    
    XMNavigationController *homeNav = [[XMNavigationController alloc]initWithRootViewController:[HomeViewController new]];
    [self addChildViewController:homeNav];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [[UIColor blueColor] colorWithAlphaComponent:0.4]} forState:UIControlStateSelected];
    
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"icon_tabbar_addressbook_normal"] selectedImage:[[UIImage imageNamed:@"icon_tabbar_addressbook_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *appleCodeNav = [[UINavigationController alloc]initWithRootViewController:[PrincipleViewController new]];
    [self addChildViewController:appleCodeNav];
    appleCodeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"寻根溯源" image:[UIImage imageNamed:@"icon_tabbar_discover_normal"] selectedImage:[[UIImage imageNamed:@"icon_tabbar_discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    XMNavigationController *fullScrrenPop_Nav = [[XMNavigationController alloc]initWithRootViewController:[MyViewController new]];
    [self addChildViewController:fullScrrenPop_Nav];
    fullScrrenPop_Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"icon_tabbar_my_normal"] selectedImage:[[UIImage imageNamed:@"icon_tabbar_my_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedViewController"] )
    {
        // wire the interaction controller to the view controller
        [_panInteractionGesture wireToViewController:self.selectedViewController
                                             forOperation:JLInteractionOperationTab];
    }
}



- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {
    
    NSUInteger fromVCIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toVCIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    _animationController.reverse = fromVCIndex < toVCIndex;
    return _animationController;
}

-(id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return _panInteractionGesture.interactionInProgress ? _panInteractionGesture : nil;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end

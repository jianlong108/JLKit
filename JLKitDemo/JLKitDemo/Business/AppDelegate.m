//
//  AppDelegate.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"

#define USE_INJECTIONIII 0

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = NO;
    }

#if USE_INJECTIONIII
#if DEBUG
#if TARGET_OS_SIMULATOR
    NSString *injectionBundlePath = @"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle";
#else
    NSString *injectionBundlePath = [[NSBundle mainBundle] pathForResource:@"iOSInjection_Device" ofType:@"bundle"];
#endif
    NSBundle *injectionBundle = [NSBundle bundleWithPath:injectionBundlePath];
    if (injectionBundle) {
        [injectionBundle load];
    } else {
        NSLog(@"Not Found Injection Bundle");
    }
#endif
#endif
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self.window makeKeyAndVisible];
    
    TabBarViewController *tabarController = [[TabBarViewController alloc]init];
    
    self.window.rootViewController = tabarController;
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

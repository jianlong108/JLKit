//
//  CustomKVOVC.m
//  low-level-analyse
//
//  Created by Wangjianlong on 2017/10/15.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "CustomKVOVC.h"
#import "NSObject+KVO.h"

@interface CustomKVOVC ()

@property(nonatomic,strong) NSMutableArray *testArray;
@property(nonatomic,strong) NSString *testString;

@end

@implementation CustomKVOVC

-(void)dealloc{
    [self JL_removeObserver:self forKey:@"testString"];
    [self JL_removeObserver:self forKey:@"testArray"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.testArray = [NSMutableArray arrayWithObject:@"one"];
    
//TODO
    //当和系统的kvo同时注册时,就会出现死循环..还需要完善代码
//    [self addObserver:self forKeyPath:@"testString" options:NSKeyValueObservingOptionNew context:nil];
    
    [self JL_addObserver:self forKey:@"testString" withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue)
    {
        NSLog(@"new = %@ old = %@ key = %@ object = %@",newValue,oldValue,observedKey,observedObject);
    }];
    
//    [self JL_addObserver:self forKey:@"testArray" withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue)
//     {
//         NSLog(@"new = %@ old = %@ key = %@ object = %@",newValue,oldValue,observedKey,observedObject);
//     }];
    
    
//    [self addObserver:self forKeyPath:@"testString" options:NSKeyValueObservingOptionNew context:nil];
    
    self.testString = @"你好,自定义的kvo";
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.testString = @"值发生改变了";
    
    [self.testArray addObject: @"two"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change);
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

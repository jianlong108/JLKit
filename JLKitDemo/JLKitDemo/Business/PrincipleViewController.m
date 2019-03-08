//
//  PrincipleViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2019/3/4.
//  Copyright © 2019 JL. All rights reserved.
//

#import "PrincipleViewController.h"
#import "SimpleCell.h"
#import "SimpleItem.h"

@interface PrincipleViewController ()

@end

@implementation PrincipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:SimpleCell_ReuseIdentifer];
    
    OTSectionModel *section = [[OTSectionModel alloc]init];
    SimpleItem *item = [[SimpleItem alloc]init];
    item.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    item.title = @"消息转发";
    item.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        UIViewController *vc = [[NSClassFromString(@"MethodForwardVC") alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section.items addObject:item];
    
    item = [[SimpleItem alloc]init];
    item.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    item.title = @"class解惑";
    item.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        UIViewController *vc = [[NSClassFromString(@"ClassLayoutVC") alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section.items addObject:item];
    
    item = [[SimpleItem alloc]init];
    item.title = @"自己实现KVO";
    item.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    item.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        UIViewController *vc = [[NSClassFromString(@"CustomKVOVC") alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section.items addObject:item];
    
    [self.sectionItems addObject:section];
    
    [self.tableView reloadData];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    Method_Bus *bus = [[Method_Bus alloc]init];
//    NSLog(@"%@",bus.class);
//
//    NSLog(@"%@",self.class);
//    NSLog(@"%@",super.class);

//    int multiplier = 6;
//    __block int multiplier = 6;
//    int (^myBlock)(int) = ^(int num) {
//        //block 内部想要修改外部变量,变量需要加__block修饰
////        NSLog(@"%d",multiplier);
//        multiplier +=2;
//        return num * multiplier;
//    };
//    NSLog(@"%d",myBlock(2));
//    NSLog(@"%d",multiplier);


//    NSMutableArray *mArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"abc",nil];
//    NSMutableArray *mArrayCount = [NSMutableArray arrayWithCapacity:1];
//    [mArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock: ^(NSString *obj,NSUInteger idx, BOOL *stop){
//        [mArrayCount addObject:[NSNumber numberWithUnsignedInteger:obj.length]];
//    }];

//    NSLog(@"%@",self);




//    [self runtime_class_test];
//
//    [self addnewclass];
//
//    LockTest *test = [[LockTest alloc]init];
//    [test lock_test];
//}


@end

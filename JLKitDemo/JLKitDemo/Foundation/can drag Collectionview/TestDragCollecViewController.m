//
//  TestDragCollecViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/15.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TestDragCollecViewController.h"
#import "JLTabMoreView.h"

@interface TestDragCollecViewController ()
/**datasource*/
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation TestDragCollecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    JLTabMoreView *moreview = [[JLTabMoreView alloc]initMoreTabViewWithItems:self.dataSource Frame:self.view.bounds];
    [self.view addSubview:moreview];
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i<10; i++) {
            JLCellitem *item = [[JLCellitem alloc]init];
            [item setTitle:[NSString stringWithFormat:@"数据%d",i]];
            [_dataSource addObject:item];
        }
        
    }
    return _dataSource;
}


@end

//
//  TestCollectionViewController.m
//  JLKitDemo
//
//  Created by mi on 2017/8/25.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "OTCollectionViewDataSource.h"
#import "WaterFlowLayout.h"

@interface TestCollectionViewController ()<UICollectionViewDelegate>
/**<#message#>*/
@property (nonatomic, weak) UICollectionView *collectionView;
/**<#message#>*/
@property (nonatomic, strong) WaterFlowLayout *flowLayout;

/**数据源*/
@property (nonatomic, strong) OTCollectionViewDataSource *datasource;

@end

@implementation TestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WaterFlowLayout *flowLayout = [[WaterFlowLayout alloc]init];
    _flowLayout = flowLayout;
    flowLayout.column = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.5, 0, 0.5);
    if ([UIScreen mainScreen].bounds.size.width >= 375) {
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.75, 0, 0.75);;
    }
    UICollectionView *functionMainView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    functionMainView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
    _datasource = [[OTCollectionViewDataSource alloc]init];
    functionMainView.dataSource = _datasource;
    functionMainView.delegate = self;
    [functionMainView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"my_functionMainView"];
    [self.view addSubview:functionMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

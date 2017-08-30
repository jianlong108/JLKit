//
//  OTCollectionViewDataSource.m
//  JLKitDemo
//
//  Created by mi on 2017/8/25.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "OTCollectionViewDataSource.h"

@implementation OTCollectionViewDataSource

#pragma mark - collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"my_functionMainView" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"my_functionMainView_header" forIndexPath:indexPath];
    
}


@end

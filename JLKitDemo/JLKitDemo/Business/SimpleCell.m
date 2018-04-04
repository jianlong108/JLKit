//
//  SimpleCell.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/4/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "SimpleCell.h"
#import "SimpleModel.h"

@implementation SimpleCell

- (void)setUpItem:(SimpleModel *)item
{
    self.textLabel.text = item.title;
}

@end

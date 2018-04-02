//
//  OTTableViewCell.m
//  MiTalk
//
//  Created by mi on 2017/8/31.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "OTTableViewCell.h"

@implementation OTTableViewCell

@synthesize item = _item;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initlizeContentViews];
        [self layoutContentViews];
    }
    return self;
}

- (void)initlizeContentViews
{
    
}

- (void)layoutContentViews
{
    
}

- (void)setUpItem:(id<OTItemProtocol> )item
{
    _item = item;
}

@end

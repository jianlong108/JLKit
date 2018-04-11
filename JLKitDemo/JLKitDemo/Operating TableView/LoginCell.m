//
//  LoginCell.m
//  我的控件集合
//
//  Created by Wangjianlong on 2017/8/12.
//  Copyright © 2017年 autohome. All rights reserved.
//

#import "LoginCell.h"
#import "SimpleItem.h"

@implementation LoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUpItem:(SimpleItem *)item{
    
}
@end

//
//  TagCellTableViewCell.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPotocol.h"
#import "TagItem.h"
extern NSString * const TagCellTableViewCell_ReuseIdentifer;

@interface TagCellTableViewCell : UITableViewCell<OTCellProtocol>


/**<#message#>*/
@property (nonatomic, strong) TagItem *item;

@end

//
//  SettingCheckItem.h
//  MiTalk
//
//  Created by mi on 2017/8/15.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "SettingItem.h"

@interface SettingCheckItem : SettingItem
/**是否选中*/
@property (nonatomic, assign,getter=isSelected)  BOOL selected;

@end

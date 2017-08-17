//
//  OTPotocol.h
//  我的控件集合
//
//  Created by Wangjianlong on 2017/8/12.
//  Copyright © 2017年 Wangjianlong. All rights reserved.
//  Operating TableView 简单方便使用TableView


#import <UIKit/UIKit.h>

#ifndef SetCell_h
#define SetCell_h

typedef void (^SettingCellClickBlock)(id);

@protocol OTItemProtocol <NSObject>

@required
@property (nonatomic, strong) NSIndexPath *indexPath;

- (NSString *)titleOfCell;

- (SettingCellClickBlock)doSomeThingOfClickCell;

- (NSString *)reuseableIdentierOfCell;

@optional
- (UIImage *)imageOfCell;
- (CGFloat)heightOfCell;
- (NSString *)tagTextOfCell;
- (BOOL)switchStateOfCell;

@end

@protocol OTCellProtocol <NSObject>

@required
- (void)setUpItem:(id<OTItemProtocol>)item;


@end

@protocol OTGroupItemProtocol <NSObject>

@required
- (NSArray< id<OTItemProtocol> > *)itemsOfGroup;

@optional
- (CGFloat )heightOfGroupHeader;
- (CGFloat )heightOfGroupFooter;
- (NSString *)headerOfGroup;
- (NSString *)footerOfGroup;

@end


#endif /* SetCell_h */

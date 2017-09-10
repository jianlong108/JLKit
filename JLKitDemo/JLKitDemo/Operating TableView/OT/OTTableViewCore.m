//
//  OTTableViewCore.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/9/10.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "OTTableViewCore.h"

@implementation OTTableViewCore

- (NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

#pragma mark - Table view items source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<OTGroupItemProtocol> group = self.items[section];
    return [[group itemsOfGroup] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OTGroupItemProtocol> group = self.items[indexPath.section];
    
    id<OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    item.indexPath = indexPath;
    UITableViewCell<OTCellProtocol> *cell;
    
    NSString *identifer = [item reuseableIdentierOfCell];
    cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    [cell setUpItem:[group itemsOfGroup][indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    id<OTGroupItemProtocol> group = self.items[section];
    return [group heightOfGroupHeader];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    id<OTGroupItemProtocol> group = self.items[section];
    return [group heightOfGroupFooter];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    id<OTGroupItemProtocol> group = self.items[indexPath.section];
    id <OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    
    if ([item doSomeThingOfClickCell]) { // block有值(点击这个cell,.有特定的操作需要执行)
        [item doSomeThingOfClickCell](item);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<OTGroupItemProtocol> group = self.items[indexPath.section];
    
    id<OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    return [item heightOfCell];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<OTGroupItemProtocol> group = self.items[section];
    if ([group respondsToSelector:@selector(headerOfGroup)]) {
        return [group headerOfGroup];
    }else{
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    id<OTGroupItemProtocol> group = self.items[section];
    if ([group respondsToSelector:@selector(footerOfGroup)]) {
        return [group footerOfGroup];
    }else{
        return nil;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id<OTGroupItemProtocol> group = self.items[section];
    if ([group respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [group tableView:tableView viewForHeaderInSection:section];
    }else{
        return nil;
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    id<OTGroupItemProtocol> group = self.items[section];
    if ([group respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [group tableView:tableView viewForFooterInSection:section];
    }else{
        return nil;
    }
    
}

@end

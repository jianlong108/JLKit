//
//  OTTableViewPivot.m
//  MiTalk
//
//  Created by 王建龙 on 2017/9/8.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "OTTableViewPivot.h"


@implementation OTTableViewPivot

- (NSMutableArray *)sectionItems {
    if (_sectionItems == nil) {
        _sectionItems = [NSMutableArray array];
    }
    return _sectionItems;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    return [[group itemsOfGroup] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<OTSectionItemProtocol> group = self.sectionItems[indexPath.section];
    
    id<OTItemProtocol,OTLayoutItemProtocol> item = (id<OTItemProtocol,OTLayoutItemProtocol>)[group itemsOfGroup][indexPath.row];
    if ([item respondsToSelector:@selector(setIndexPath:)]) {
        item.indexPath = indexPath;
    }
    if ([item respondsToSelector:@selector(setLaseRow:)]) {
        item.laseRow = [[[group itemsOfGroup] lastObject] isEqual:item];
    }
    
    UITableViewCell<OTCellProtocol> *cell;
    NSString *identifer = [item reuseableIdentierOfCell];
    cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    [cell setUpItem:item];
    
    if ([cell respondsToSelector:@selector(setDelegateObjectForSelf:)]) {
        [cell setDelegateObjectForSelf:self.hostObject];
    }
    
    if ([item conformsToProtocol:@protocol(OTLayoutItemProtocol)]){
        
    }
    
    if ([cell respondsToSelector:@selector(setOuterMargin:)]) {
        cell.outerMargin = item.outerMargin;
    }
    if ([cell respondsToSelector:@selector(setInnerMargin:)]) {
        cell.innerMargin = item.innerMargin;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    return [group heightOfGroupHeader];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    return [group heightOfGroupFooter];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    id<OTSectionItemProtocol> group = self.sectionItems[indexPath.section];
    id <OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    
    if ([item respondsToSelector:@selector(cellClickBlock)]) {
        if (item.cellClickBlock) { // block有值(点击这个cell,.有特定的操作需要执行)
            item.cellClickBlock(item,indexPath);
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<OTSectionItemProtocol> group = self.sectionItems[indexPath.section];
    
    id<OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    return [item heightOfCell];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(headerOfGroup)]) {
        return [group headerOfGroup];
    }
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(footerOfGroup)]) {
        return [group footerOfGroup];
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [group tableView:tableView viewForHeaderInSection:section];
    }else{
        return nil;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [group tableView:tableView viewForFooterInSection:section];
    }else{
        return nil;
    }
}
@end

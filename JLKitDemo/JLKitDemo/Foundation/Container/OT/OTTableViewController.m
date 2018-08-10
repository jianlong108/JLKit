//
//  OTTableViewController.m
//  Pods
//
//  Created by 王建龙 on 2017/9/14.
//
//

#import "OTTableViewController.h"
#import "OTTableView.h"

@interface OTTableViewController ()

@property(nonatomic, strong) OTTableView *tableView;

@property(nonatomic, strong) NSMutableArray *sectionItems;

@property (nonatomic, strong) NSIndexPath *indexPathOfRespondEventCell;

@property(nonatomic, strong) id<OTItemProtocol> itemOfRespondEventCell;

@end

@implementation OTTableViewController

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (OTTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[OTTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


#pragma mark - data
- (NSMutableArray<id<OTSectionItemProtocol>> *)sectionItems
{
    if (_sectionItems == nil) {
        _sectionItems = [NSMutableArray array];
    }
    return _sectionItems;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    return [[group itemsOfSection] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OTSectionItemProtocol> group = self.sectionItems[indexPath.section];
    
    id<OTItemProtocol,OTLayoutItemProtocol> item = (id<OTItemProtocol,OTLayoutItemProtocol>)[group itemsOfSection][indexPath.row];
    if ([item respondsToSelector:@selector(setIndexPath:)]) {
        item.indexPath = indexPath;
    }
    if ([item respondsToSelector:@selector(setLastRow:)]) {
        item.lastRow = [[[group itemsOfSection] lastObject] isEqual:item];
    }
    
    UITableViewCell<OTCellProtocol> *cell;
    NSString *identifer = [item reuseableIdentierOfCell];
    cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if ([cell respondsToSelector:@selector(setUpItem:)]) {
        [cell setUpItem:[group itemsOfSection][indexPath.row]];
    }
    
    if ([cell respondsToSelector:@selector(setDelegateObjectForSelf:)]) {
        [cell setDelegateObjectForSelf:self];
    }
    
    if ([item conformsToProtocol:@protocol(OTLayoutItemProtocol)]){
        
    }
    
    if ([cell respondsToSelector:@selector(setOuterMargin:)]) {
        cell.outerMargin = item.outerMargin;
    }
    if ([cell respondsToSelector:@selector(setInnerMargin:)]) {
        cell.innerMargin = item.innerMargin;
    }
    
    if ([item respondsToSelector:@selector(configCellWhenCellIsCreated:)]) {
        [item configCellWhenCellIsCreated:cell];
    }
    
    [self configCellWhenCellIsCreated:cell indexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"wjl cell == nil please check tableview have regitster cell for identifer %@",identifer);
    }
    
    return cell;
}

- (void)configCellWhenCellIsCreated:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    return [group heightOfGroupHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    return [group heightOfGroupFooter];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    id<OTSectionItemProtocol> group = self.sectionItems[indexPath.section];
    id <OTItemProtocol> item = [group itemsOfSection][indexPath.row];
    
    if ([item respondsToSelector:@selector(cellClickBlock)]) {
        if (item.cellClickBlock) { // block有值(点击这个cell,.有特定的操作需要执行)
            item.cellClickBlock(item,indexPath);
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OTSectionItemProtocol> group = self.sectionItems[indexPath.section];
    
    id<OTItemProtocol> item = [group itemsOfSection][indexPath.row];
    return [item heightOfCell];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(headerOfGroup)]) {
        return [group headerOfGroup];
    }
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(footerOfGroup)]) {
        return [group footerOfGroup];
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [group tableView:tableView viewForHeaderInSection:section];
    }else{
        return nil;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    id<OTSectionItemProtocol> group = self.sectionItems[section];
    if ([group respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [group tableView:tableView viewForFooterInSection:section];
    }else{
        return nil;
    }
}

- (void)visibleCellRespondEventAtIndexPath:(NSIndexPath *)indexPath event:(UIEvent *)event
{
    _indexPathOfRespondEventCell = indexPath;
    _itemOfRespondEventCell = [self getRowItemWithIndexPath:indexPath];
}

- (id<OTItemProtocol>)getRowItemWithIndexPath:(NSIndexPath *)indexPath
{
    @synchronized(self) {
        if (indexPath.section >= self.sectionItems.count) {
            return nil;
        }
        id<OTSectionItemProtocol>section = self.sectionItems[indexPath.section];
        if (indexPath.item >= section.itemsOfSection.count) {
            return nil;
        }
        return [section.itemsOfSection objectAtIndex:indexPath.item];
    }
    
}

@end

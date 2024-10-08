//
//  OTTableViewController.m
//  Pods
//
//  Created by 王建龙 on 2017/9/14.
//
//

#import "OTTableViewController.h"

@interface OTTableViewController ()

@property(nonatomic, strong) OTTableView *tableView;

@property(nonatomic, strong) NSMutableArray *sectionItems;

@property (nonatomic, strong) NSIndexPath *indexPathOfRespondEventCell;

@property(nonatomic, strong) id<OTItemProtocol> itemOfRespondEventCell;

@end

@implementation OTTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.tableView showTitlesContentView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.tableView hiddenTitlesContentView];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[[self innerTableViewClass] alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        NSLog(@"wjl cell == nil please check tableview have regitster cell for identifer: %@",identifer);
        cell = (UITableViewCell<OTCellProtocol> *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
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
    
//    pthread_mutex_lock(&_mutex);
    if (indexPath.section >= self.sectionItems.count) {
//        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    id<OTSectionItemProtocol>section = self.sectionItems[indexPath.section];
    if (indexPath.item >= section.itemsOfSection.count) {
//        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    
//    pthread_mutex_unlock(&_mutex);
    return [section.itemsOfSection objectAtIndex:indexPath.item];
}

@end

@implementation OTTableViewController(indexPath)

- (NSIndexPath *)getIndexPathWithItemModel:(id<OTItemProtocol>)model
{
//    pthread_mutex_lock(&_mutex);
    if (!model || self.sectionItems.count<= 0) {
//        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    NSIndexPath *indexPath = nil;
    
    NSUInteger section = 0;
    
    for (id obj in self.sectionItems) {
        if ([obj conformsToProtocol:@protocol(OTSectionItemProtocol)]) {
            id <OTSectionItemProtocol>modelProtocol = obj;
            if ([modelProtocol.itemsOfSection containsObject:model]) {
                NSUInteger index = [modelProtocol.itemsOfSection indexOfObject:model];
                indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            }
            section ++;
        }
    }

//    pthread_mutex_unlock(&_mutex);
    return indexPath;
}

- (NSIndexSet *)getIndexSetWithSectionModel:(id<OTSectionItemProtocol>)model
{
//    pthread_mutex_lock(&_mutex);
    if (!model || self.sectionItems.count<= 0) {
//        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    NSIndexSet *indexSet = nil;
    
    NSUInteger index = [self.sectionItems indexOfObject:model];
    if (index != NSNotFound) {
        indexSet = [NSIndexSet indexSetWithIndex:index];
    }
//    pthread_mutex_unlock(&_mutex);
    return indexSet;
}

@end

@implementation OTTableViewController(reloadData)

- (void)reloadSectionWithSectionModel:(id<OTSectionItemProtocol>)model withRowAnimation:(UITableViewRowAnimation)animation
{
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (!model) {
        return;
    }
    NSIndexSet *indexSet = [self getIndexSetWithSectionModel:model];
    if (indexSet) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            [self.tableView performBatchUpdates:^{
                [self.tableView reloadSections:indexSet withRowAnimation:animation];
            } completion:^(BOOL finished) {
                
            }];
        }
#else
        [self.tableView beginUpdates];
        [self.tableView reloadSections:indexSet withRowAnimation:animation];
        [self.tableView endUpdates];
#endif
    }
}

- (void)reloadRowWithItemModel:(id<OTItemProtocol>)model withRowAnimation:(UITableViewRowAnimation)animation
{
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (!model) {
        return;
    }
    NSIndexPath *indexPath = [self getIndexPathWithItemModel:model];
    if (indexPath) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            [self.tableView performBatchUpdates:^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
            } completion:^(BOOL finished) {
                
            }];
        }
        
#else
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        [self.tableView endUpdates];
#endif
    }
}
- (void)reloadRowsWithItemModels:(NSArray <id<OTItemProtocol>>*)models withRowAnimation:(UITableViewRowAnimation)animation
{
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (models.count <= 0) {
        return;
    }
    NSMutableArray <NSIndexPath *>*indexpaths = [NSMutableArray arrayWithCapacity:models.count];
    for (id<OTItemProtocol>model in models) {
        NSIndexPath *indexPath = [self getIndexPathWithItemModel:model];
        if (indexPath) {
            [indexpaths addObject:indexPath];
        }
    }
    
    if (indexpaths.count > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            [self.tableView performBatchUpdates:^{
                [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:animation];
            } completion:^(BOOL finished) {
                
            }];
        }
        
#else
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:animation];
        [self.tableView endUpdates];
#endif
    }
}

@end

@implementation OTTableViewController(subClassHook)

- (Class)innerTableViewClass
{
    return [OTTableView class];
}

@end

//
//  OTTableViewController.h
//  Pods
//
//  Created by 王建龙 on 2017/9/14.
//
//

#import <UIKit/UIKit.h>
#import "OTHeader.h"
#import "OTTableView.h"


@interface OTTableViewController : UIViewController<
    OTTableViewDataSource,
    OTTableViewDelegate
>


@property(nonatomic, readonly) NSMutableArray< id<OTSectionItemProtocol> > *sectionItems;

//tableView class name is define by function - (Class)innerTableViewClass;
//default is OTTableView
@property(nonatomic, readonly) OTTableView *tableView;

@property(nonatomic, readonly) NSIndexPath *indexPathOfRespondEventCell;
@property(nonatomic, readonly) id<OTItemProtocol> itemOfRespondEventCell;


- (id<OTItemProtocol>)getRowItemWithIndexPath:(NSIndexPath *)indexPath;

//override by subClass For customConfigCell when cell is Created
- (void)configCellWhenCellIsCreated:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

// Subclasses must always call super if they override.
- (void)visibleCellRespondEventAtIndexPath:(NSIndexPath *)indexPath event:(UIEvent *)event;

@end

@interface OTTableViewController(indexPath)

- (NSIndexPath *)getIndexPathWithItemModel:(id<OTItemProtocol>)model;
- (NSIndexSet *)getIndexSetWithSectionModel:(id<OTSectionItemProtocol>)model;

@end

@interface OTTableViewController(reloadData)

- (void)reloadSectionWithSectionModel:(id<OTSectionItemProtocol>)model withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadRowWithItemModel:(id<OTItemProtocol>)model withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowsWithItemModels:(NSArray <id<OTItemProtocol>>*)models withRowAnimation:(UITableViewRowAnimation)animation;

@end

@interface OTTableViewController(subClassHook)

- (Class)innerTableViewClass;

@end

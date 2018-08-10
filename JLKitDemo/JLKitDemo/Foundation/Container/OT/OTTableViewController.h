//
//  OTTableViewController.h
//  Pods
//
//  Created by 王建龙 on 2017/9/14.
//
//

#import <UIKit/UIKit.h>
#import "OTHeader.h"


@interface OTTableViewController : UIViewController<
    UITableViewDelegate,
    UITableViewDataSource,
    OTTableViewDelegate
>


@property(nonatomic, readonly) NSMutableArray *sectionItems;

@property(nonatomic, readonly) OTTableView *tableView;

@property(nonatomic, readonly) NSIndexPath *indexPathOfRespondEventCell;
@property(nonatomic, readonly) id<OTItemProtocol> itemOfRespondEventCell;


- (id<OTItemProtocol>)getRowItemWithIndexPath:(NSIndexPath *)indexPath;

//override by childClass For customConfigCell when cell is Created
- (void)configCellWhenCellIsCreated:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

// Subclasses must always call super if they override.
- (void)visibleCellRespondEventAtIndexPath:(NSIndexPath *)indexPath event:(UIEvent *)event;

@end


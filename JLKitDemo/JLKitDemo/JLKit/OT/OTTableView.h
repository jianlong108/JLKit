//
//  OTTableView.h
//  XMContainer
//
//  Created by wangjianlong on 2018/6/13.
//

#import <UIKit/UIKit.h>
#import "UITableView+IndexBar.h"
#import "MTTableViewSectionIndexBar.h"

@protocol OTTableViewDelegate <UITableViewDelegate>

- (void)visibleCellRespondEventAtIndexPath:(NSIndexPath *)indexPath event:(UIEvent *)event;

@optional

- (void)sectionIndexBar:(MTTableViewSectionIndexBar *)sectionIndexBar sectionDidSelected:(NSUInteger)index title:(NSString *)title;

@end


@protocol OTTableViewDataSource<UITableViewDataSource>

@optional
// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSArray<NSString *> *)customSectionIndexTitlesForTableView:(UITableView *)tableView;

@end

@interface OTTableView : UITableView

@property (nonatomic, weak) id<OTTableViewDelegate> delegate;
@property (nonatomic, weak) id<OTTableViewDataSource> dataSource;

@end


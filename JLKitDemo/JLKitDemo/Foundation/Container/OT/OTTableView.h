//
//  OTTableView.h
//  XMContainer
//
//  Created by wangjianlong on 2018/6/13.
//

#import <UIKit/UIKit.h>

@protocol OTTableViewDelegate <UITableViewDelegate>

- (void)visibleCellRespondEventAtIndexPath:(NSIndexPath *)indexPath event:(UIEvent *)event;

@end

@interface OTTableView : UITableView

@property (nonatomic, weak) id<OTTableViewDelegate> delegate;

@end

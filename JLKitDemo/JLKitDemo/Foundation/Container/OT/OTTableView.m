//
//  OTTableView.m
//  XMContainer
//
//  Created by wangjianlong on 2018/6/13.
//

#import "OTTableView.h"

@implementation OTTableView

@dynamic delegate;


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [self handlePoint:point event:event];
    return [super hitTest:point withEvent:event];
}

- (void)handlePoint:(CGPoint)point event:(UIEvent *)event
{
    __block UITableViewCell *touchCell;
    [self.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            touchCell = obj;
            *stop = YES;
        }
    }];
    
    if (touchCell) {
        NSIndexPath *indexPath = [self indexPathForCell:touchCell];
        if ([self.delegate respondsToSelector:@selector(visibleCellRespondEventAtIndexPath:event:)]) {
            [self.delegate visibleCellRespondEventAtIndexPath:indexPath event:event];
        }
    }
}

@end

//
//  OTTableView.m
//  XMContainer
//
//  Created by wangjianlong on 2018/6/13.
//

#import "OTTableView.h"

@interface OTTableView()<MTTableViewSectionIndexBarDelegate>


@end

@implementation OTTableView
@dynamic dataSource;
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

- (void)sectionIndexBar:(MTTableViewSectionIndexBar *)sectionIndexBar sectionDidSelected:(NSUInteger)index title:(NSString *)title{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)reloadData
{
    [super reloadData];
    if ([self.dataSource respondsToSelector:@selector(customSectionIndexTitlesForTableView:)]) {
        NSArray <NSString *>*sectionTitles = [self.dataSource customSectionIndexTitlesForTableView:self];
        self.mtSectionIndexBarDataSource = sectionTitles;
        
    }
}

@end

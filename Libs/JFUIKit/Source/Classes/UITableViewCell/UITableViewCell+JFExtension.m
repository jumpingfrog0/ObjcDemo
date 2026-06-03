//
//  UITableViewCell+JFExtension.m
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import "UITableViewCell+JFExtension.h"

@implementation UITableViewCell (JFExtension)

+ (NSString *)jf_reuseIdentifier
{
    return NSStringFromClass(self);
}

- (void)jf_setCornerRadius:(CGFloat)radius tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [tableView numberOfRowsInSection:indexPath.section];
    self.layer.mask = nil;
    if (rowCount <= 0) {
        return;
    }

    UIRectCorner corners = 0;
    if (rowCount == 1) {
        corners = UIRectCornerAllCorners;
    } else if (indexPath.row == 0) {
        corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    } else if (indexPath.row == rowCount - 1) {
        corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }

    if (corners == 0 || CGRectIsEmpty(self.bounds)) {
        return;
    }

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(radius, radius)];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

@end

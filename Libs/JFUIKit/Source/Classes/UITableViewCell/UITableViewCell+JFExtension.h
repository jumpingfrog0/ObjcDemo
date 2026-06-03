//
//  UITableViewCell+JFExtension.h
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (JFExtension)

/**
 * 返回当前 Cell 类名作为复用标识
 */
+ (NSString *)jf_reuseIdentifier;

/**
 * 根据 Cell 在 section 中的位置设置圆角
 */
- (void)jf_setCornerRadius:(CGFloat)radius tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

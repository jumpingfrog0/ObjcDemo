//
//  UICollectionViewCell+JFExtension.h
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (JFExtension)

/**
 * 返回当前 Cell 类名作为复用标识
 */
+ (NSString *)jf_reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

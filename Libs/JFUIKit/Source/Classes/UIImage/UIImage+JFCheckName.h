//
//  UIImage+JFCheckName.h
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import <UIKit/UIKit.h>

@interface UIImage (JFCheckName)

/**
 * 启用 imageNamed: 缺图检查。Debug 下缺图会触发断言，Release 下保持返回 nil。
 */
+ (void)jf_enableImageNamedCheck;

@end

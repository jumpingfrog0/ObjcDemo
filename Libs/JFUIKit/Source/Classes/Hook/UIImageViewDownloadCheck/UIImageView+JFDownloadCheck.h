//
//  UIImageView+JFDownloadCheck.h
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JFImageViewDownloadCheckLogger)(NSURL *url, NSError *error);

@interface UIImageView (JFDownloadCheck)

/**
 * 启用 SDWebImage 下载失败检查。该 Hook 只在显式调用后生效。
 */
+ (void)jf_enableDownloadCheckWithLogger:(nullable JFImageViewDownloadCheckLogger)logger;

@end

NS_ASSUME_NONNULL_END

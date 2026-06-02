//
//  NSURL+JFOSSImageURL.h
//  JFFoundation
//
//  Created by huangdonghong on 2026/06/02.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JFWebpUrlContentMode) {
    JFWebpUrlContentModeScaleAspectFill,
    JFWebpUrlContentModeScaleAspectFillOver,
    JFWebpUrlContentModeScaleAspectFit,
    JFWebpUrlContentModeScaleToFill
};

@interface NSURL (JFOSSImageURL)

+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr;
+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width;
+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr height:(CGFloat)height;
+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr quality:(CGFloat)quality;
+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width height:(CGFloat)height;
+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width quality:(CGFloat)quality;
+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality;
+ (nullable instancetype)jf_webpWithUrlStr:(NSString *)urlStr width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality mode:(JFWebpUrlContentMode)mode;

@end

NS_ASSUME_NONNULL_END

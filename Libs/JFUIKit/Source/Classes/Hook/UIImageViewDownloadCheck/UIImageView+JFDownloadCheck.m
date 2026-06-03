//
//  UIImageView+JFDownloadCheck.m
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import "UIImageView+JFDownloadCheck.h"
#import <objc/runtime.h>
#import <SDWebImage/SDWebImageError.h>
#import <SDWebImage/UIImageView+WebCache.h>

static JFImageViewDownloadCheckLogger jf_downloadCheckLogger = nil;

@implementation UIImageView (JFDownloadCheck)

+ (void)jf_enableDownloadCheckWithLogger:(JFImageViewDownloadCheckLogger)logger
{
    jf_downloadCheckLogger = [logger copy];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sd_setImageWithURL:placeholderImage:options:progress:completed:);
        SEL swizzledSelector = @selector(jf_checked_sd_setImageWithURL:placeholderImage:options:progress:completed:);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        if (originalMethod && swizzledMethod) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)jf_checked_sd_setImageWithURL:(nullable NSURL *)url
                     placeholderImage:(nullable UIImage *)placeholder
                              options:(SDWebImageOptions)options
                             progress:(nullable SDImageLoaderProgressBlock)progressBlock
                            completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self jf_checked_sd_setImageWithURL:url
                       placeholderImage:placeholder
                                options:options
                               progress:progressBlock
                              completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error && error.code != SDWebImageErrorCancelled && [imageURL isKindOfClass:NSURL.class] && imageURL.absoluteString.length > 0) {
            if (jf_downloadCheckLogger) {
                jf_downloadCheckLogger(imageURL, error);
            } else {
                NSLog(@"SD Load Image Url : %@, Error : %@", imageURL, error);
            }
        }
        
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}

@end

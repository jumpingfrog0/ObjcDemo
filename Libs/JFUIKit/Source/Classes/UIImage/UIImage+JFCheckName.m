//
//  UIImage+JFCheckName.m
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import "UIImage+JFCheckName.h"
#import <objc/runtime.h>

@implementation UIImage (JFCheckName)

+ (void)jf_enableImageNamedCheck
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getClassMethod(self, @selector(imageNamed:));
        Method swizzledMethod = class_getClassMethod(self, @selector(jf_checkedImageNamed:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

+ (UIImage *)jf_checkedImageNamed:(NSString *)name
{
    UIImage *image = [self jf_checkedImageNamed:name];
#if DEBUG
    if (name.length > 0 && image == nil) {
        NSAssert(NO, @"image name 异常，请检查是否存在该图标: %@", name);
    }
#endif
    return image;
}

@end

//
//  UICollectionViewCell+JFExtension.m
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import "UICollectionViewCell+JFExtension.h"

@implementation UICollectionViewCell (JFExtension)

+ (NSString *)jf_reuseIdentifier
{
    return NSStringFromClass(self);
}

@end

//
//  NSMutableDictionary+JFExtension.m
//  JFFoundation
//
//  Created by huangdonghong on 2026/06/02.
//

#import "NSMutableDictionary+JFExtension.h"

@implementation NSMutableDictionary (JFExtension)

- (void)jf_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end

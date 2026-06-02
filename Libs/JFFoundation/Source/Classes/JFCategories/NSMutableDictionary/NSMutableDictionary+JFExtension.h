//
//  NSMutableDictionary+JFExtension.h
//  JFFoundation
//
//  Created by huangdonghong on 2026/06/02.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (JFExtension)

- (void)jf_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END

//
//  NSError+JFExtension.h
//  JFFoundation
//
//  Created by huangdonghong on 2026/06/02.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const JFErrorDomain;

@interface NSError (JFExtension)

+ (NSError *)jf_errorWithMessage:(nullable NSString *)message;
+ (NSError *)jf_errorWithCode:(NSInteger)code message:(nullable NSString *)message;
- (NSError *)jf_errorWithMessage:(nullable NSString *)message;

@end

NS_ASSUME_NONNULL_END

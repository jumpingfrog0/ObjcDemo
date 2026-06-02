//
//  NSError+JFExtension.m
//  JFFoundation
//
//  Created by huangdonghong on 2026/06/02.
//

#import "NSError+JFExtension.h"

NSErrorDomain const JFErrorDomain = @"JFErrorDomain";

@implementation NSError (JFExtension)

+ (NSError *)jf_errorWithMessage:(NSString *)message
{
    return [self jf_errorWithCode:-2 message:message];
}

+ (NSError *)jf_errorWithCode:(NSInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:JFErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: message ?: @"未知错误"}];
}

- (NSError *)jf_errorWithMessage:(NSString *)message
{
    return [NSError errorWithDomain:self.domain
                               code:self.code
                           userInfo:@{NSLocalizedDescriptionKey: message ?: @"未知错误"}];
}

@end

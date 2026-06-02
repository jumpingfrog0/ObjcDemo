//
//  NSObject+JFExtension.m
//  JFFoundation
//
//  Created by huangdonghong on 2018/08/01.
//
//
//  Copyright (c) 2017 huangdonghong
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSObject+JFExtension.h"
#import <objc/runtime.h>

@implementation NSObject (JFExtension)

- (id)jf_safeValueForKey:(NSString *)key
{
    if (key.length == 0 || ![self respondsToSelector:NSSelectorFromString(key)]) {
        return nil;
    }

    @try {
        return [self valueForKey:key];
    } @catch (__unused NSException *exception) {
        return nil;
    }
}

- (void)jf_safeSetValue:(id)value forKey:(NSString *)key
{
    if (key.length == 0) {
        return;
    }

    NSString *first = [[key substringToIndex:1] uppercaseString];
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", first, [key substringFromIndex:1]];
    if (![self respondsToSelector:NSSelectorFromString(setterName)]) {
        return;
    }

    @try {
        [self setValue:value forKey:key];
    } @catch (__unused NSException *exception) {
    }
}

- (instancetype)jf_copyWithZone:(NSZone *)zone
{
    id object = [[[self class] allocWithZone:zone] init];
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (unsigned int index = 0; index < outCount; index++) {
        Ivar ivar = ivars[index];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([self.jf_ignoredIvarNames containsObject:key]) {
            continue;
        }
        @try {
            id value = [self valueForKey:key];
            if (value) {
                [object setValue:value forKey:key];
            }
        } @catch (__unused NSException *exception) {
        }
    }
    free(ivars);
    return object;
}

- (void)jf_encode:(NSCoder *)aCoder
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (unsigned int index = 0; index < outCount; index++) {
        Ivar ivar = ivars[index];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([self.jf_ignoredIvarNames containsObject:key]) {
            continue;
        }
        @try {
            id value = [self valueForKey:key];
            if (value) {
                [aCoder encodeObject:value forKey:key];
            }
        } @catch (__unused NSException *exception) {
        }
    }
    free(ivars);
}

- (void)jf_decode:(NSCoder *)aDecoder
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (unsigned int index = 0; index < outCount; index++) {
        Ivar ivar = ivars[index];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([self.jf_ignoredIvarNames containsObject:key]) {
            continue;
        }
        id value = [aDecoder decodeObjectForKey:key];
        if (value) {
            @try {
                [self setValue:value forKey:key];
            } @catch (__unused NSException *exception) {
            }
        }
    }
    free(ivars);
}

- (void)setJf_ignoredIvarNames:(NSArray<NSString *> *)jf_ignoredIvarNames
{
    objc_setAssociatedObject(self, @selector(jf_ignoredIvarNames), jf_ignoredIvarNames, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<NSString *> *)jf_ignoredIvarNames
{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSArray<NSString *> *)jf_propertyKeys
{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];

    for (unsigned int index = 0; index < outCount; index++) {
        objc_property_t property = properties[index];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if (propertyName.length > 0) {
            [keys addObject:propertyName];
        }
    }

    free(properties);
    return keys;
}

- (NSDictionary *)jf_dictionaryWithProperties
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in [self jf_propertyKeys]) {
        id propertyValue = [self jf_safeValueForKey:key];
        if (!propertyValue || [propertyValue isKindOfClass:[NSNull class]]) {
            continue;
        }

        if ([propertyValue isKindOfClass:[NSDate class]]) {
            propertyValue = [NSString stringWithFormat:@"%f", [propertyValue timeIntervalSince1970]];
        }
        [dict setObject:propertyValue forKey:key];
    }
    return [dict copy];
}

- (id)jf_performSelector:(SEL)sel withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
    if (signature == nil) {
        return nil;
    }

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = sel;

    // setting arguments
    NSInteger paramsCount = signature.numberOfArguments - 2; // except the arguments: self, _cmd
    paramsCount = MIN(paramsCount, objects.count);

    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i + 2];
    }

    [invocation invoke];

    const char *returnType = signature.methodReturnType;
    id returnValue;

    if (!strcmp(returnType, @encode(void))) {
        // If return type is void, then that is no return value
        returnValue = nil;
    } else if (!strcmp(returnType, @encode(id))) {
        // If return type is object, then set value for variable
        [invocation getReturnValue:&returnValue];
    } else {
        // If return type is basic type(NSInteger, BOOL, Double)
        // get return length
        NSUInteger length = signature.methodReturnLength;

        // apply memory according to length
        void *buffer = (void *) malloc(length);

        // set value
        [invocation getReturnValue:buffer];

        if (!strcmp(returnType, @encode(BOOL))) {
            returnValue = @(*((BOOL *) buffer));
        } else if (!strcmp(returnType, @encode(NSInteger))) {
            returnValue = @(*((NSInteger *) buffer));
        } else {
            returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
        }
        free(buffer);
    }

    return returnValue;
}
@end

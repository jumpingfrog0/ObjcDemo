//
//  NSDictionary+JFSafe.m
//  JFFoundation
//
//  Created by huangdonghong on 2023/6/27.
//

#import "NSDictionary+JFSafe.h"

@implementation NSDictionary (JFSafe)

- (NSNumber *)jf_safeNumberForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSNull class]]) {
        return @(0);
    }
    return object;
}

- (NSNumber *)jf_safeNumberOrNilForKey:(NSString *)key
{
    id object = [self objectForKey:key];

    if (![object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

- (NSNumber *)jf_safeNumberForKey:(id)key defaultValue:(NSNumber *)defaultValue
{
    return [self jf_safeObjectForKey:key expectedClass:[NSNumber class] defaultValue:defaultValue];
}

- (NSNumber *)jf_safeNumberForKeyCompatibleString:(id)key
{
    id result = [self jf_safeObjectForKey:key expectedClass:[NSNumber class]];
    if (!result) {
        result = [self jf_safeObjectForKey:key expectedClass:[NSString class]];
    }
    return result;
}

- (NSString *)jf_safeStringForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return object;
}

- (NSString *)jf_safeStringOrNilForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

- (NSString *)jf_safeStringForKey:(id)key defaultValue:(NSString *)defaultValue
{
    return [self jf_safeObjectForKey:key expectedClass:[NSString class] defaultValue:defaultValue];
}

- (NSString *)jf_safeStringForKeyCompatibleNumber:(id)key
{
    id result = [self jf_safeObjectForKey:key expectedClass:[NSString class]];
    if (!result) {
        result = [self jf_safeObjectForKey:key expectedClass:[NSNumber class]];
    }

    if ([result isKindOfClass:[NSNumber class]]) {
        result = [(NSNumber *)result stringValue];
    }
    return result;
}

- (NSArray *)jf_safeArrayForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSNull class]]) {
        return @[];
    }
    return object;
}

- (NSArray *)jf_safeArrayOrNilForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

- (NSArray *)jf_safeArrayForKey:(id)key defaultValue:(NSArray *)defaultValue
{
    return [self jf_safeObjectForKey:key expectedClass:[NSArray class] defaultValue:defaultValue];
}

- (NSDictionary *)jf_safeDictionaryForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSNull class]]) {
        return @{};
    }
    return object;
}

- (NSDictionary *)jf_safeDictionaryOrNilForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

- (NSDictionary *)jf_safeDictionaryForKey:(id)key defaultValue:(NSDictionary *)defaultValue
{
    return [self jf_safeObjectForKey:key expectedClass:[NSDictionary class] defaultValue:defaultValue];
}

- (NSData *)jf_safeDataForKey:(id)key
{
    return [self jf_safeDataForKey:key defaultValue:nil];
}

- (NSData *)jf_safeDataForKey:(id)key defaultValue:(NSData *)defaultValue
{
    return [self jf_safeObjectForKey:key expectedClass:[NSData class] defaultValue:defaultValue];
}

- (id)jf_safeObjectForKey:(id)key expectedClass:(Class)cls
{
    return [self jf_safeObjectForKey:key expectedClass:cls defaultValue:nil];
}

- (id)jf_safeObjectForKey:(id)key expectedClass:(Class)cls defaultValue:(id)defaultValue
{
    id object = [self objectForKey:key];
    if (cls && [object isKindOfClass:cls]) {
        return object;
    }
    return defaultValue;
}

@end

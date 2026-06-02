//
//  NSDictionary+JFSafe.h
//  JFFoundation
//
//  Created by huangdonghong on 2023/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JFSafe)

- (NSNumber *)jf_safeNumberForKey:(NSString *)key;
- (NSNumber *)jf_safeNumberOrNilForKey:(NSString *)key;
- (NSNumber *)jf_safeNumberForKey:(id)key defaultValue:(nullable NSNumber *)defaultValue;
- (NSNumber *)jf_safeNumberForKeyCompatibleString:(id)key;

- (NSString *)jf_safeStringForKey:(NSString *)key;
- (NSString *)jf_safeStringOrNilForKey:(NSString *)key;
- (NSString *)jf_safeStringForKey:(id)key defaultValue:(nullable NSString *)defaultValue;
- (NSString *)jf_safeStringForKeyCompatibleNumber:(id)key;

- (NSArray *)jf_safeArrayForKey:(NSString *)key;
- (NSArray *)jf_safeArrayOrNilForKey:(NSString *)key;
- (NSArray *)jf_safeArrayForKey:(id)key defaultValue:(nullable NSArray *)defaultValue;

- (NSDictionary *)jf_safeDictionaryForKey:(NSString *)key;
- (NSDictionary *)jf_safeDictionaryOrNilForKey:(NSString *)key;
- (NSDictionary *)jf_safeDictionaryForKey:(id)key defaultValue:(nullable NSDictionary *)defaultValue;

- (NSData *)jf_safeDataForKey:(id)key;
- (NSData *)jf_safeDataForKey:(id)key defaultValue:(nullable NSData *)defaultValue;

- (id)jf_safeObjectForKey:(id)key expectedClass:(Class)cls;
- (id)jf_safeObjectForKey:(id)key expectedClass:(Class)cls defaultValue:(nullable id)defaultValue;

@end

NS_ASSUME_NONNULL_END

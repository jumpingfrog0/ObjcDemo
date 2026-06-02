//
//  NSMutableArray+JFSafe.m
//  JFFoundation
//
//  Created by huangdonghong on 2023/6/25.
//

#import "NSMutableArray+JFSafe.h"

@implementation NSMutableArray (JFSafe)

- (BOOL)jf_indexValidate:(NSUInteger)index
{
    return index < self.count;
}

- (void)jf_safeAddObject:(id)obj
{
    if (obj) {
        [self addObject:obj];
    }
}

- (void)jf_safeRemoveFirstObject
{
    if (self.count > 0) {
        [self removeObjectAtIndex:0];
    }
}

- (void)jf_safeRemoveLastObject
{
    if (self.count > 0) {
        [self jf_safeRemoveObjectAtIndex:self.count - 1];
    }
}

- (void)jf_safeRemoveObjectAtIndex:(NSUInteger)index
{
    if ([self jf_indexValidate:index]) {
        [self removeObjectAtIndex:index];
    }
}

- (void)jf_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if ([self jf_indexValidate:index] && anObject != nil) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)jf_safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if ([self jf_indexValidate:index] && anObject != nil) {
        [self insertObject:anObject atIndex:index];
    }
}

- (id)jf_safePopFirstObject
{
    id object = nil;
    if (self.count > 0) {
        object = self.firstObject;
        [self jf_safeRemoveFirstObject];
    }
    return object;
}

- (id)jf_safePopLastObject
{
    id object = nil;
    if (self.count > 0) {
        object = self.lastObject;
        [self jf_safeRemoveLastObject];
    }
    return object;
}

- (NSMutableArray *)jf_upsetData
{
    NSMutableArray *result = [self mutableCopy];
    for (NSUInteger index = result.count; index > 1; index--) {
        [result exchangeObjectAtIndex:index - 1 withObjectAtIndex:arc4random_uniform((uint32_t)index)];
    }
    return result;
}

@end

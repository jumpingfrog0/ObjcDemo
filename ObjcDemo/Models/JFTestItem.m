//
//  JFTestItem.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/1/19.
//

#import "JFTestItem.h"

@implementation JFTestItem

- (instancetype)initWithTitle:(NSString *)title actionBlock:(JFTestItemActionBlock)actionBlock
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _actionBlock = [actionBlock copy];
    }
    return self;
}

@end

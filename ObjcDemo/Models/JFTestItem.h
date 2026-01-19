//
//  JFTestItem.h
//  ObjcDemo
//
//  Created by huangdonghong on 2026/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^JFTestItemActionBlock)(void);

@interface JFTestItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) JFTestItemActionBlock actionBlock;

- (instancetype)initWithTitle:(NSString *)title actionBlock:(nullable JFTestItemActionBlock)actionBlock;

@end

NS_ASSUME_NONNULL_END

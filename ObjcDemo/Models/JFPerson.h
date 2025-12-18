//
//  JFPerson.h
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFPerson : NSObject

@property (nonatomic, strong) NSString *wsName;

//@property (nonatomic, assign) int age;

//@property (nonatomic, strong) NSMutableArray *dataArray;

+ (instancetype)sharedInstance;

- (JFPerson *)retObj;

+ (instancetype)retObj;

@end

NS_ASSUME_NONNULL_END

//
//  JFRoomChatView.h
//  ObjcDemo
//
//  Created by huangdonghong on 2026/01/05.
//

#import <UIKit/UIKit.h>
#import "JFRoomChatModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 直播间公屏容器视图
 */
@interface JFRoomChatView : UIView

/**
 最大消息数量，超过则自动删除旧消息
 */
@property (nonatomic, assign) NSInteger maxMessageCount;

/**
 初始化方法
 
 @param frame 框架
 @return 公屏容器视图实例
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 添加一条公屏消息
 
 @param messageModel 消息模型
 */
- (void)addMessage:(JFRoomChatModel *)messageModel;

/**
 添加多条公屏消息
 
 @param messageModels 消息模型数组
 */
- (void)addMessages:(NSArray<JFRoomChatModel *> *)messageModels;

/**
 清空所有消息
 */
- (void)clearAllMessages;

@end

NS_ASSUME_NONNULL_END

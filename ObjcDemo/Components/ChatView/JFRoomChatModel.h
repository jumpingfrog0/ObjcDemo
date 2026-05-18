//
//  JFRoomChatModel.h
//  ObjcDemo
//
//  Created by AI Assistant on 2026/01/05.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 公屏消息类型
 */
typedef NS_ENUM(NSInteger, JFRoomChatMessageType) {
    JFRoomChatMessageTypeText = 0,    // 普通文本消息
    JFRoomChatMessageTypeSystem,      // 系统消息
};

/**
 直播间公屏消息模型
 */
@interface JFRoomChatModel : NSObject

/**
 消息类型
 */
@property (nonatomic, assign) JFRoomChatMessageType messageType;

/**
 消息内容
 */
@property (nonatomic, copy) NSString *content;

/**
 头像URL（仅普通消息有效）
 */
@property (nonatomic, copy, nullable) NSString *avatarURL;

/**
 昵称（仅普通消息有效）
 */
@property (nonatomic, copy, nullable) NSString *nickname;

/**
 初始化普通文本消息
 
 @param content 消息内容
 @param nickname 昵称
 @param avatarURL 头像URL
 @return 消息模型实例
 */
- (instancetype)initWithTextContent:(NSString *)content 
                          nickname:(NSString *)nickname 
                         avatarURL:(nullable NSString *)avatarURL;

/**
 初始化系统消息
 
 @param content 消息内容
 @return 消息模型实例
 */
- (instancetype)initWithSystemContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END

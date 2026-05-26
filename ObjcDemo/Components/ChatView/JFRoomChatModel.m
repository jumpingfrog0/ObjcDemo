//
//  JFRoomChatModel.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/01/05.
//

#import "JFRoomChatModel.h"

@implementation JFRoomChatModel

/**
 初始化普通文本消息
 
 @param content 消息内容
 @param nickname 昵称
 @param avatarURL 头像URL
 @return 消息模型实例
 */
- (instancetype)initWithTextContent:(NSString *)content 
                          nickname:(NSString *)nickname 
                         avatarURL:(nullable NSString *)avatarURL {
    if (self = [super init]) {
        _messageType = JFRoomChatMessageTypeText;
        _content = [content copy];
        _nickname = [nickname copy];
        _avatarURL = [avatarURL copy];
    }
    return self;
}

/**
 初始化系统消息
 
 @param content 消息内容
 @return 消息模型实例
 */
- (instancetype)initWithSystemContent:(NSString *)content {
    if (self = [super init]) {
        _messageType = JFRoomChatMessageTypeSystem;
        _content = [content copy];
    }
    return self;
}

@end

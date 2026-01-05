//
//  JFRoomChatTextCell.h
//  ObjcDemo
//
//  Created by AI Assistant on 2026/01/05.
//

#import "JFRoomChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 直播间普通文本消息Cell
 */
@interface JFRoomChatTextCell : JFRoomChatBaseCell

/**
 头像ImageView
 */
@property (nonatomic, strong) UIImageView *avatarImageView;

/**
 昵称Label
 */
@property (nonatomic, strong) UILabel *nicknameLabel;

/**
 内容Label
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 气泡背景View
 */
@property (nonatomic, strong) UIView *bubbleBackgroundView;

@end

NS_ASSUME_NONNULL_END

//
//  JFRoomChatSystemCell.h
//  ObjcDemo
//
//  Created by AI Assistant on 2026/01/05.
//

#import "JFRoomChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 直播间系统消息Cell
 */
@interface JFRoomChatSystemCell : JFRoomChatBaseCell

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

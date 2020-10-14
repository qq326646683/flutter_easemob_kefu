//
//  HDjudgeTextMessageSubType.h
//  helpdesk_sdk
//
//  Created by afanda on 1/18/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>


__attribute__((deprecated("已过期, 请使用HDMessageHelper ")))
@interface HDjudgeTextMessageSubType : NSObject

+ (BOOL)isTrackMessage:(HDMessage *)message;     //轨迹消息
+ (BOOL)isOrderMessage:(HDMessage *)message;     //订单消息
+ (BOOL)isMenuMessage:(HDMessage *)message;      //菜单消息
+ (BOOL)isTransferMessage:(HDMessage *)message;  //转接客服消息
+ (BOOL)isEvaluateMessage:(HDMessage *)message;  //满意度评价消息
+ (BOOL)isFormMessage:(HDMessage *)message; //机器人表单消息

@end

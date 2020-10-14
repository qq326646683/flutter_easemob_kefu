//
//  HDRobotMenuInfo.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

@interface HDMenuItem : NSObject
@property (nonatomic, strong) NSString *menuName; // 文字显示内容
@property (nonatomic) BOOL isTransferNoteItem; // 是否是留言item

@end


@interface HDMenuInfo : NSObject
@property (nonatomic, strong) NSArray *items; // 每项内容
@property (nonatomic, strong) NSString *title; // 菜单tiile
@property (nonatomic, strong) NSString *content; // 菜单描述

@end

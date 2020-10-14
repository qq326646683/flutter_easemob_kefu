//
//  HDMessage+Menu.h
//  helpdesk_sdk
//
//  Created by 杜洁鹏 on 2019/8/9.
//  Copyright © 2019 hyphenate. All rights reserved.
//

#import "HDMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDMessage (Menu)
// 返回菜单
- (HDMenuInfo *)menuInfo;

@end

NS_ASSUME_NONNULL_END

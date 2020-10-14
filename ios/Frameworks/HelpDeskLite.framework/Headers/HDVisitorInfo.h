//
//  VisitorInfo.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HDContent.h"

@interface HDVisitorInfo : HDContent
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* qq;
@property (nonatomic, copy) NSString* companyName;
@property (nonatomic, copy) NSString* nickName;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, copy) NSString* email;
@end

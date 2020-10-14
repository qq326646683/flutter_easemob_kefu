//
//  HDControlMessage.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HDCompositeContent.h"
#import "HDContent.h"

FOUNDATION_EXPORT NSString * const TYPE_EVAL_REQUEST;
FOUNDATION_EXPORT NSString * const TYPE_EVAL_RESPONSE;
FOUNDATION_EXPORT NSString * const TYPE_TRANSFER_TO_AGENT;


@interface ControlType : HDContent

@property (nonatomic, copy) NSString * ctrlType;

-(instancetype) initWithValue:(NSString *)value;

@end

@interface ControlArguments : HDContent
@property (nonatomic, copy) NSString* identity;
@property (nonatomic, copy) NSString* sessionId;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, copy) NSString* detail;
@property (nonatomic, copy) NSString* summary;
@property (nonatomic, copy) NSString* inviteId;
@end

@interface HDControlMessage : HDCompositeContent

@property (nonatomic, strong) ControlType *type;
@property (nonatomic, strong) ControlArguments *arguments;

@end


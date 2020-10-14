//
//  HDTransferIndication.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HDCompositeContent.h"
#import "HDContent.h"
#import "HDAgentInfo.h"

@interface Event: HDContent
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* obj;

-(instancetype) initWithObject:(NSMutableDictionary *)obj;
@end

@interface HDTransferIndication : HDCompositeContent
@property (nonatomic, strong) HDAgentInfo * agentInfo;
@property (nonatomic, strong) Event *event;
-(instancetype) initWithContents:(NSMutableDictionary *)obj;
@end



//
//  HDMessage+Content.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/6/14.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDMessage (Content)
- (void)addContent:(HDContent *)content;
- (void)addCompositeContent:(HDCompositeContent *)content;
@end

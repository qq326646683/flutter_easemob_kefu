/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#ifndef HDLocalDefine_h
#define HDLocalDefine_h

#define LocalStringBundle(key, comment) \
({\
NSBundle *mainbundle = [NSBundle bundleForClass:[self class]];\
NSString *myBundlePath = [mainbundle pathForResource:@"HelpDeskUIResource" ofType:@"bundle"];\
NSBundle *myBundle = [NSBundle bundleWithPath:myBundlePath];\
NSString *str = [myBundle localizedStringForKey:(key) value:@"" table:nil];\
(str);\
})\


#define hd_dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#define hd_dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }


#endif /* HDLocalDefine_h */

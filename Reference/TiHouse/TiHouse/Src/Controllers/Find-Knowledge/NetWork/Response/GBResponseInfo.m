//
//  GBResponseInfo.m
//  GB_Football
//
//  Created by weilai on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "AppDelegate.h"

@implementation GBResponseInfo

- (BOOL)isAdapterSuccess {

    return _is == RequestSuccessCode;
}

- (NSInteger)responseCode {
    return _is;
}

- (NSString *)responseMsg {
    return _msg;
}

/**
 * @brief 重置数据
 */
- (void)resetResponseInfo {
    _is = 0;
    _msg = nil;
}

@end

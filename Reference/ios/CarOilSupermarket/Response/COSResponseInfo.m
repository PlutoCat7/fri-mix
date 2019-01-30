//
//  COSResponseInfo.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@implementation COSResponseInfo

- (BOOL)isAdapterSuccess {
    
    return _code == RequestSuccessCode;
}

- (NSInteger)responseCode {
    return _code;
}

- (NSString *)responseMsg {
    return _msg;
}

/**
 * @brief 重置数据
 */
- (void)resetResponseInfo {
    _code = 0;
    _msg = nil;
}

@end

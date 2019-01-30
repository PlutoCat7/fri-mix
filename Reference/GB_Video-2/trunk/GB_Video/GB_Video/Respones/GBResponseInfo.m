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
    
    switch (_code) {
        case RESULT_ERROR_TOKEN_NOT:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
            if (_code != RESULT_ERROR_TOKEN_NOT) {  //sid失效不提示
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.window showToastWithText:_msg];
            }
        }
            break;
            
        default:
            break;
    }

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

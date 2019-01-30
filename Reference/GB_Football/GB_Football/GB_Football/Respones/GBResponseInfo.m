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
        case RESULT_ERROR_USER_OPE_EXPIRE_TIME:
        case Request_ERROR_USER_PASSWORD_NOT_SAME:
        case RESULT_ERROR_TOKEN_NOT:
        case RESULT_ERROR_NOT_LOGIN:
        case RESULT_ERROR_PHONE_SAME_LOGIN:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
            if (_code != RESULT_ERROR_TOKEN_NOT) {  //sid失效不提示
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.window showToastWithText:_msg];
            }
        }
            break;
        case RESULT_ERROR_TEAM_NOT_ADDED:
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_NOT_ADDED object:nil];
            break;
        case RESULT_ERROR_TEAM_ADDED:
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_ADDED object:nil];
            break;
        case RESULT_Has_Leave_Match:
        case RESULT_Has_Delete_Match:
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeleteMatchSuccess object:nil];
            [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"inivte-you-kicked-out-tips")];
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

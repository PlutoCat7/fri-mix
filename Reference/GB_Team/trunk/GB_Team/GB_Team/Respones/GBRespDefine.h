//
//  GBRespDefine.h
//  GB_Football
//
//  Created by weilai on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#ifndef GBRespDefine_h
#define GBRespDefine_h

#define RequestSuccessCode 0
#define Request_ERROR_API_GENERAL 40000
#define RESULT_ERROR_NOT_LOGIN -13                 //没有登录错误
#define RESULT_ERROR_USER_OPE_EXPIRE_TIME -15      //用户操作超时,请重新登录
#define Request_ERROR_USER_PASSWORD_NOT_SAME -14   //密码变更,请重新登录
#define RESULT_ERROR_PHONE_SAME_LOGIN     -26      //相同手机号码在不同手机号码登录
#define RESULT_ERROR_TOKEN_NOT -39                 //客户端没有传递sid参数, 重新登录

typedef NS_ENUM(NSUInteger, RequestErrorCode) {
    RequestErrorCodeUnknow = -1,
    RequestErrorCodeSession = 1000,      // session无效错误
    RequestErrorCodeNetwork = 2000,      // 网络无法连接
    RequestErrorCodeCanceled = -999,      // 请求取消
    RequestErrorCodeTimeOut = -1001,      // 连接超时
};

#endif /* GBRespDefine_h */

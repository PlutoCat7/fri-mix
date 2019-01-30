//
//  GBRespDefine.h
//  GB_Football
//
//  Created by weilai on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#ifndef GBRespDefine_h
#define GBRespDefine_h

#define RequestSuccessCode 1

typedef NS_ENUM(NSUInteger, RequestErrorCode) {
    RequestErrorCodeUnknow = -1,
    RequestErrorCodeSession = 1000,      // session无效错误
    RequestErrorCodeNetwork = 2000,      // 网络无法连接
    RequestErrorCodeHTTP = 2001,      // 接口错误
    RequestErrorCodeCanceled = -999,      // 请求取消
    RequestErrorCodeTimeOut = -1001,      // 连接超时
};

#endif /* GBRespDefine_h */

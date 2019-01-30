//
//  URLConstants.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#ifndef URLConstants_h
#define URLConstants_h

/////////debug环境判断//////////////
#ifdef DEBUG

#define ServerAPIBaseURL    @"http://testapi-video.t-goal.com/apps/"
#define ServerHost    @"testapi-video.t-goal.com"

#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define GBLog(...) printf("%s %s 第%d行: %s\n\n",[[[NSDate date] stringWithFormat:@"YYYY-MM-dd hh:mm:ss.SSS"] UTF8String], [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#define KGBDebug    YES

#else

//#define ServerAPIBaseURL    @"http://api-video.t-goal.com/apps/"
//#define ServerHost    @"api-video.t-goal.com"
#define ServerAPIBaseURL    @"http://testapi-video.t-goal.com/apps/"
#define ServerHost    @"testapi-video.t-goal.com"
#define GBLog(format, ...)

#define KGBDebug    NO

#endif
///////////////////////////////////

//检验密钥
#define URL_CHECK_KEY @"99585980f891460c19s8d2f22f389820"
// 头部参数
#define AND_CLIENT_TYPE 1
#define IOS_CLIENT_TYPE 2

#define HEAD_CLIENT_TYPE @"clienttype"
#define HEAD_SESSION_ID @"sessionid"
#define HEAD_USER_ID @"uid"
#define KEY_SID @"sid"


// 手环连接成功，但是无法正常通信，错误上报
#define KBlueTooth_Error_Code  5555
#define KBlueTooth_Error_Uri  @"bluetooth.read.fail"

#endif /* URLConstants_h */

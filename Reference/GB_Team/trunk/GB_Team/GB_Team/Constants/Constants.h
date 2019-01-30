//
//  Constants.h
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/////////debug环境判断//////////////
#ifdef DEBUG

#define ServerAPIBaseURL    @"http://testteamapiv1.t-goal.com/apps/"
//#define ServerAPIBaseURL    @"http://teamapiv1.t-goal.com/apps/"
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define GBLog(...) printf("%s %s 第%d行: %s\n\n",[[[NSDate date] stringWithFormat:@"YYYY-MM-dd hh:mm:ss.SSS"] UTF8String], [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else

//#define ServerAPIBaseURL    @"http://testteamapiv1.t-goal.com/apps/"
#define ServerAPIBaseURL    @"http://teamapiv1.t-goal.com/apps/"
#define GBLog(format, ...)

#endif

// 环境配置
#define AND_CLIENT_TYPE 1
#define IOS_CLIENT_TYPE 2

// 极光推送appkey
#define JPush_App_Key @"9dea284ab0ae5e9d032d7244"

// 高德appkey
#define GAODE_App_Key @"91e912feea3ec2b4d2d487a6e4031bc9"

// 友盟appkey
#define UM_App_Key @"5833c04c3eae2573bf001030"

//网页地址
#define Tgoal_User_Agreement @"http://www.t-goal.com/Home/Index/xy"
#define Tgoal_Introduce      @"http://www.t-goal.com/Home/Index/help_new.html"

//通知
#define Notification_NeedLogin @"Notification_NeedLogin"
#define Notification_ShowMainView @"Notification_ShowMainView"

#define Notification_CreatePlayerSuccess @"Notification_CreatePlayerSuccess"
#define Notification_EditPlayerSuccess @"Notification_EditPlayerSuccess"

#define Notification_CreateTeamSuccess @"Notification_CreateTeamSuccess"
#define Notification_EditTeamSuccess @"Notification_EditTeamSuccess"

#define Notification_CreateCourtSuccess @"Notification_CreateCourtSuccess"

#define Notification_CreateMatchSuccess @"Notification_CreateMatchSuccess"
#define Notification_DeleteMatchSuccess @"Notification_DeleteMatchSuccess"
#define Notification_CompleteMatchSuccess @"Notification_CompleteMatchSuccess"

#define Notification_ResetCourtSuccess  @"Notification_ResetCourtSuccess"
#define Notification_RestartLocate      @"Notification_RestartLocate"

// 头部参数
#define HEAD_CLIENT_TYPE @"clienttype"
#define HEAD_USER_ID @"uid"
#define KEY_SID @"sid"

#endif /* Constants_h */

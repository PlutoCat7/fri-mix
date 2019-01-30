//
//  Enums.h
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#ifndef Enums_h
#define Enums_h


typedef enum
{
    ActionType_NeedLogin = 0,//需要登录
    ActionType_ShowError,  //显示错误
    ActionType_ImplicitError, //隐式错误，不显示，但可以返回错误内容
    ActionType_DataIsLoading, //数据正在加载
    ActionType_DataIsUploading, //数据正在上载
    ActionType_EndOfList //列表已经到尾部
} TTActionType;

// 性别
typedef enum
{
    SexType_Unknow = -1,
    SexType_Female,
    SexType_Male,
    SexType_Secret
} SexType;

// 球场类型
typedef enum
{
    CourtType_Standard = 0,
    CourtType_Define
}CourtType;

typedef enum : NSUInteger {
    iBeaconVersion_None = 0,
    iBeaconVersion_T_Goal = 1,      //tgoal
    iBeaconVersion_T_Goal_S = 2,    //里皮版
} iBeaconVersion;

#endif /* Enums_h */

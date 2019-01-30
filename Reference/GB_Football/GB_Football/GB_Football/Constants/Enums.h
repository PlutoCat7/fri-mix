//
//  Enums.h
//  GB_Football
//
//  Created by weilai on 16/2/21.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#ifndef Enums_h
#define Enums_h

// 性别
typedef enum
{
    SexType_Unknow = -1,
    SexType_Female,
    SexType_Male,
    SexType_Secret
} SexType;

// 球员位置
typedef enum
{
    FPosType_GK = 0, //守门员
    FPosType_LB,     //左后卫
    FPosType_CB,     //中后卫
    FPosType_RB,     //右后卫
    FPosType_DMF,    //后腰
    FPosType_LMF,    //左前卫
    FPosType_CMF,    //中前卫
    FPosType_RMF,    //右前卫
    FPosType_AMF,    //前腰
    FPosType_CF      //前锋
} FPosType;

// 球场类型
typedef enum
{
    CourtType_Standard = 0,
    CourtType_Define
}CourtType;

// 比赛类型
typedef enum
{
    GameType_Standard = 0,
    GameType_Define,
    GameType_Team,
}GameType;

typedef enum
{
    ActionType_NeedLogin = 0,//需要登录
    ActionType_ShowError,  //显示错误
    ActionType_ImplicitError, //隐式错误，不显示，但可以返回错误内容
    ActionType_DataIsLoading, //数据正在加载
    ActionType_DataIsUploading, //数据正在上载
    ActionType_EndOfList //列表已经到尾部
} TTActionType;

typedef enum
{
    FriendStatus_Addable = 0, //可添加
    FriendStatus_Invited, //被邀请
    FriendStatus_Added, // 已添加
    
}FriendStatus;

//被邀请比赛状态
typedef NS_ENUM(NSUInteger, FriendInviteMatchStatus) {
    FriendInviteMatchStatus_Idle = 0,  //未被邀请
    FriendInviteMatchStatus_invited,   //已被邀请
};

typedef enum
{
    PushType_None = -1,
    PushType_Friend = 1,
    PushType_MatchData,
    PushType_InsideWeb,
    PushType_OutsideWeb,
    PushType_MatchInvite = 10000,  //比赛邀请推送
    PushType_TEAM_APPLY = 10001,   //申请加入球队
    PushType_TEAM_ACCEPT_APPLY = 10002,  //通过加入球队的申请
    PushType_TEAM_REFUSE_APPLY = 10003,  //拒绝加入球队的申请
    PushType_TEAM_INVITE = 10004,   //球队邀请
    PushType_TEAM_ACCEPT_INVITE = 10005,  //通过邀请
    PushType_TEAM_APPOINT_LEADER_DEPUTY = 10006, //任命为副队长
    PushType_TEAM_DISMISS = 10007, //踢出球队
    PushType_TEAM_TRAN = 10008, //移交队长
    PushType_TEAM_REMOVE_LEADER_DEPUTY = 10009,  //解除副队长
} PushType;

typedef enum {
    TeamPalyerType_Captain = 1,   //队长
    TeamPalyerType_ViceCaptain,  //副队长
    TeamPalyerType_Ordinary,   //普通成员
} TeamPalyerType;

typedef enum
{
    DailyRank_Distance = 1,
    DailyRank_ENERGY,
    DailyRank_Step,
}DailyRank;

typedef enum
{
    DailyGroup_Week = 1,
    DailyGroup_Month,
    DailyGroup_Days
}DailyGroup;

typedef enum
{
    MatchRank_Distance = 1,
    MatchRank_AveSpeed,
    MatchRank_MaxSpeed,
    MatchRank_Energy,
}MatchRank;

typedef enum
{
    PlayerRank_Score = 1,
    PlayerRank_Speed,
    PlayerRank_Endur,
    PlayerRank_Erupt,
    PlayerRank_Sprint,
    PlayerRank_Distance,
    PlayerRank_Area,
}PlayerRank;

typedef enum
{
    MatchRankType_Match = 1,
    MatchRankType_History,
}MatchRankType;

// 设备连接状态
typedef enum
{
    /**
     *  Used for initialization and unknown error states
     */
    BeanState_Unknown = 0,
    /**
     *  Bean has been discovered by a central
     */
    BeanState_Discovered,
    /**
     *  Bean is attempting to connect with a central
     */
    BeanState_AttemptingConnection,
    /**
     *  Bean is undergoing validation,暂时不用
     */
    BeanState_AttemptingValidation,
    /**
     *  Bean is connected
     */
    BeanState_ConnectedAndValidated,
    /**
     *  Bean is disconnecting
     */
    BeanState_AttemptingDisconnection
    
} BeanState;

typedef enum
{
    /**
     *  An input argument was invalid
     */
    BeanErrors_InvalidArgument = 0,
    /**=
     *  Bluetooth is not turned on
     */
    BeanErrors_BluetoothNotOn,
    /**
     *  The bean is not connected
     */
    BeanErrors_NotConnected,
    /**
     *  No Peripheral discovered with corresponding UUID
     */
    BeanErrors_NoPeriphealDiscovered,
    /**
     *  Device with UUID already connected to this Bean
     */
    BeanErrors_AlreadyConnected,
    /**
     *  A device with this UUID is in the process of being connected to
     */
    BeanErrors_AlreadyConnecting,
    /**
     *  The device's current state is not eligible for a connection attempt
     */
    BeanErrors_DeviceNotEligible,
    /**
     *  No device with this UUID is currently connected
     */
    BeanErrors_FailedDisconnect,
    /**
     *  需要先连接蓝牙设备
     */
    BeanErrors_NeedConnect,
    /**
     *  设备连接失败
     */
    BeanErrors_FailedConnect,
    /**
     * 扫描设备超时
     */
    BeanErrors_ScanTimeOut,
    
} BeanError;

typedef enum
{
    /**
     *  An input argument was invalid
     */
    GattErrors_InvalidArgument = 0,
    /**
     * No connect device
     */
    GattErrors_NotConnected,
    /**
     * sync data
     */
    GattErrors_SyncData,
    /**
     * exit sync
     */
    GattErrors_ExitSync,
    /**
     * empty data
     */
    GattErrors_EmptyData,
    /**
     * parse data fail
     */
    GattErrors_PaserFail,
    /**
     * invalid commond
     */
    GattErrors_InvalidCommond,
    /**
     * time out
     */
    GattErrors_TimeOut,
    
} GattError;

typedef enum {
    SwitchModelCode_Success,
    SwitchModelCode_Fail,
    SwitchModelCode_Charging,  //充电中
}SwitchModelCode;

typedef enum {
    zh,
    en
}Language;

//地区
typedef NS_ENUM(NSUInteger, AreaType) {
    AreaType_China = 1,
    AreaType_HongKong,
    AreaType_Macao,
};

//地图类型
typedef NS_ENUM(NSUInteger, MapType) {
    MapType_Gaode = 0,
    MapType_Google,
};

//数据对比类型
typedef enum
{
    GameRankType_Count = 1,
    GameRankType_Sprint,
    GameRankType_Erupt,
    GameRankType_Endur,
    GameRankType_Area,   //覆盖面积
    GameRankType_MaxSpeed,
    GameRankType_Distance,
}GBGameRankType;

//阵型类型
typedef NS_ENUM(NSUInteger, TracticsType) {
    TracticsType_Not = 0,
    TracticsType_442 = 1,
    TracticsType_433 = 2,
    TracticsType_343 = 3,
    TracticsType_451 = 4,
    TracticsType_532 = 5,
    TracticsType_352 = 6,
    TracticsType_541 = 7,
};

//意见反馈类型
typedef NS_ENUM(NSUInteger, FeedbackType) {
    FeedbackType_Software = 1,   //软件问题
    FeedbackType_Firmware = 2,   //硬件问题
    FeedbackType_Buy = 3,        //购买问题
    FeedbackType_AfterSales = 4, //售后问题
    FeedbackType_Expect = 5,     //期望功能
    FeedbackType_praise = 6,     //赞美
};

#endif /* Enums_h */

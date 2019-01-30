//
//  NotificationConstants.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#ifndef NotificationConstants_h
#define NotificationConstants_h

//界面通知
#define Notification_NeedLogin @"Notification_NeedLogin"   //需要显示登录界面
#define Notification_ShowMainView @"Notification_ShowMainView"  //显示首页
#define Notification_NeedBindiBeacon @"Notification_NeedBindiBeacon"  //显示绑定手环界面

//---用户相关
#define Notification_User_Avator @"Notification_User_Avator"  
#define Notification_User_BaseInfo @"Notification_User_BaseInfo"  

//---蓝牙相关
#define Notification_BindSuccess @"Notification_BindSuccess"    //手环绑定成功
#define Notification_ConnectSuccess @"Notification_ConnectSuccess"    //手环连接成功
#define Notification_CancelBindSuccess @"Notification_CancelBindSuccess"  //手环解除绑定
#define Notification_CancelConenctSuccess @"Notification_CancelConenctSuccess"   //手环断开连接
#define Notification_ReadBatterySuccess @"Notification_ReadBatterySuccess"
#define Notification_DeviceCheck @"Notification_DeviceCheck"   //双击手环
#define Notification_Bluetooth_Invalid_Command @"Notification_Bluetooth_Invalid_Command"        //蓝牙协议无效，  需要升级固件
#define Notification_Bluetooth_ReadConnectInfoTimeOut @"Notification_Bluetooth_ReadConnectInfoTimeOut"        //读取手环信息超时

//---球场相关
#define Notification_CreateCourtSuccess @"Notification_CreateCourtSuccess"
#define Notification_SelectedCourt @"Notification_SelectedCourt"     //创建比赛选择球场
#define Notification_ResetCourtSuccess  @"Notification_ResetCourtSuccess"   //重新创建球场
#define Notification_DeleteCourt  @"Notification_DeleteCourt"   //删除自定义球场

//---设置相关
#define Notification_ChangeLanguageRestart @"Notification_ChangeLanguageRestart"
#define Notification_NeedUpdateFireware @"Notification_NeedUpdateFireware"

//---好友相关
#define Notification_Friend_SomeOne_add @"Notification_Friend_SomeOne_add"   //有人添加好友，点击去看看
#define Notification_Friend_SomeOne_add_RightAway @"Notification_Friend_SomeOne_add_RightAway"   //有人添加好友，马上发送通知
#define Notification_Friend_Accept @"Notification_Friend_Accept"   //接受好友添加
#define Notification_Friend_Not_Friend @"Notification_Friend_Not_Friend"  //好友关系已解除
#define Notification_Friend_Match_Friend_Selected @"Notification_Friend_Match_Friend_Selected"  //创建比赛 邀请好友

//---比赛相关
#define Notification_Match_Handle_Complete @"Notification_Match_Handle_Complete" //比赛处理完成通知
#define Notification_CreateMatchSuccess @"Notification_CreateMatchSuccess"
#define Notification_DeleteMatchSuccess @"Notification_DeleteMatchSuccess"
#define Notification_FinishMatchSuccess @"Notification_FinishMatchSuccess"

//---球队相关
#define Notification_Team_CreateSuccess @"Notification_Team_CreateSuccess"
#define Notification_Team_RemoveSuccess @"Notification_Team_RemoveSuccess"
#define Notification_Team_NOT_ADDED @"Notification_Team_NOT_ADDED"   //没有加入任何球队  操作球队接口
#define Notification_Team_ADDED @"Notification_Team_ADDED"   //已经加入球队了  操作未加入球队前的操作
#define Notification_Team_Need_Refresh @"Notification_Team_Need_Refresh"   //需要刷新球队
#define Notification_Team_Tractic_Select @"Notification_Team_Tractic_Select"   //选择球队阵容
#define Notification_Team_Player_Select @"Notification_Team_Player_Select"   //选择比赛队员
#define Notification_Team_Tactics_Add @"Notification_Team_Tactics_Add"   //球队战术创建
#define Notification_Team_Tactics_Modify @"Notification_Team_Tactics_Modify"   //球队战术修改

#endif /* NotificationConstants_h */

//
//  GattPacketConstans.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#ifndef GattPacketConstans_h
#define GattPacketConstans_h


typedef NS_ENUM(NSUInteger, FlashCleanType) {
    FlashCleanType_Unknow = 0,
    FlashCleanType_Sport = 1,  //运动
    FlashCleanType_Normal = 2, //日常
    FlashCleanType_User = 3,  //用户
    FlashCleanType_Run = 4,  //跑步
    FlashCleanType_Error = 255, //出错，当前非普通模式
};

#endif /* GattPacketConstans_h */

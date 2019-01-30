//
//  BleGlobal.h
//  GB_Football
//
//  Created by weilai on 16/3/11.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#ifndef BleGlobal_h
#define BleGlobal_h

#import <CoreBluetooth/CoreBluetooth.h>

#define member_size(type, member) sizeof(((type *)0)->member)

//XXXX091E-5084-40D0-A0B5-35853EB08309
#define PUNCHTHROUGHDESIGN_128_UUID(uuid16) uuid16 @"091E-5084-40D0-A0B5-35853EB08309"
#define GLOBAL_PACKET_SERVICE_UUID                            @"FFF0"
#define GLOBAL_WECHAT_SERVICE_UUID                            @"FEE7"
#define GLOBAL_PACKET_COMMOND_CHARACTERISTIC_UUID             PUNCHTHROUGHDESIGN_128_UUID(@"B9E3")
#define GLOBAL_PACKET_NOTIFY_CHARACTERISTIC_UUID              PUNCHTHROUGHDESIGN_128_UUID(@"BAE3")
#define GLOBAL_PACKET_NOTIFY_NEW_VERSION_CHARACTERISTIC_UUID  @"B9E30A1E-5084-40D0-A0B5-35853EB08309"  //新版手环

static const NSTimeInterval kWriteTimeInterval = 10.0;
static const NSTimeInterval kReadTimeInterval = 10.0;

typedef void (^ReadProgressBlock)(NSInteger total, NSInteger index);
typedef void (^ReadMultiServiceBlock)(id data, id sourceData, NSError *error);
typedef void (^ReadServiceBlock)(id data, NSError *error );
typedef void (^WriteServiceBlock)(NSError *error);

typedef enum : NSUInteger {
    GBBluetoothManagerState_Unknow,
    GBBluetoothManagerState_Initing,
    GBBluetoothManagerState_Complete,
} GBBluetoothManagerState;

typedef NS_ENUM(NSUInteger, BlueSwitchModel) {
    BlueSwitchModel_Unknow = -1,
    BlueSwitchModel_Normal = 0,   //日常模式
    BlueSwitchModel_Sport = 1,   //比赛模式
    BlueSwitchModel_Run = 3,     //跑步模式
};

//蓝牙任务优先级
typedef NS_ENUM(NSUInteger, GBBluetoothTask_PRIORITY_Level) {
    GBBluetoothTask_PRIORITY_Low,
    GBBluetoothTask_PRIORITY_Normal,
    GBBluetoothTask_PRIORITY_Hight,
};

#endif /* BleGlobal_h */

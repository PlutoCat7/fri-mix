//
//  GBBleConstants.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#ifndef GBBleConstants_h
#define GBBleConstants_h

//XXXX091E-5084-40D0-A0B5-35853EB08309
#define PUNCHTHROUGHDESIGN_128_UUID(uuid16) uuid16 @"091E-5084-40D0-A0B5-35853EB08309"
#define GLOBAL_PACKET_SERVICE_UUID                            @"FFF0"
#define GLOBAL_PACKET_COMMOND_CHARACTERISTIC_UUID             PUNCHTHROUGHDESIGN_128_UUID(@"B9E3")
#define GLOBAL_PACKET_NOTIFY_CHARACTERISTIC_UUID              PUNCHTHROUGHDESIGN_128_UUID(@"BAE3")
#define GLOBAL_PACKET_NOTIFY_NEW_VERSION_CHARACTERISTIC_UUID  @"B9E30A1E-5084-40D0-A0B5-35853EB08309"  //新版手环

/////////全局通知定义////////////////
#define Notification_ContectSuccess @"Notification_ContectSuccess"
#define Notification_DiscontectSuccess @"Notification_DiscontectSuccess"

/////////debug环境判断//////////////
#ifdef DEBUG

#define GBBleLog(format, ...) NSLog(format, ## __VA_ARGS__)

#else

#define GBBleLog(format, ...)

#endif

// block定义
#define BLE_BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#define BLE_BLOCK_EXEC_SetNil(block, ...) if (block) { block(__VA_ARGS__); block = nil;};

#define member_size(type, member) sizeof(((type *)0)->member)


typedef void (^ResultProgressBlock)(NSInteger total, NSInteger index);
typedef void (^ResultServiceBlock)(id parseData, id sourceData, NSError *error);

static const NSTimeInterval kScanOverTimeInterval = 30;
static const NSTimeInterval kConnectOverTimeInterval = 10;
static const NSTimeInterval kResponseTimeInterval = 10.0;

#endif /* GBBleConstants_h */

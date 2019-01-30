//
//  GattPacket.h
//  GB_Football
//
//  Created by weilai on 16/3/9.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

/**
 数据格式 0xa5 1b长度 1b命令 3~n-2内容  n-1校验(0～n-2异或校验和)
 */
#import <Foundation/Foundation.h>
#import "GattPacketConstans.h"

#define PACKET_HEAD 0xa5
#define PACKET_BACK 0x80
#define UPDATE_HEAD 0xa8
#define SEARCHSTAR_HEAD 0xa6
#define Invalid_Commond  0xfe

#define GATT_COMMON_PACKET_COUNT 0x01
#define GATT_COMMON_PACKET_COUNT_BACK 0x01|0x80
#define GATT_COMMON_PACKET 0x02
#define GATT_COMMON_PACKET_BACK 0x02|0x80

#define GATT_SPORT_PACKET_COUNT 0x03
#define GATT_SPORT_PACKET_COUNT_BACK 0x03|0x80
#define GATT_SPORT_PACKET 0x04
#define GATT_SPORT_PACKET_BACK 0x04|0x80

#define GATT_RUN_PACKET_COUNT 0x39
#define GATT_RUN_PACKET_COUNT_BACK (0x39|0x80)
#define GATT_RUN_PACKET 0x3A
#define GATT_RUN_PACKET_BACK (0x3A|0x80)

#define GATT_DATE_PACKET 0x0b
#define GATT_DATE_PACKET_BACK 0x0b|0x80

#define GATT_ADJUST_PACKET 0x0c
#define GATT_ADJUST_PACKET_BACK 0x0c|0x80

#define GATT_BATTERY_PACKET 0x0d
#define GATT_BATTERY_PACKET_BACK 0x0d|0x80

#define GATT_FIREWARE_PACKET 0x0f
#define GATT_FIREWARE_PACKET_BACK 0x0f|0x80

#define GATT_FIREWARE_COUNT_PACKET 0x14
#define GATT_FIREWARE_COUNT_PACKET_BACK 0x14|0x80

#define GATT_AGPS_COUNT_PACKET 0x24
#define GATT_AGPS_COUNT_PACKET_BACK 0x24|0x80

#define GATT_CHECK_MODEL_PACKET 0x22
#define GATT_CHECK_MODEL_PACKET_BACK 0x22|0x80

#define GATT_SWITCH_MODEL_PACKET 0x07
#define GATT_SWITCH_MODEL_PACKET_BACK 0x07|0x80;

#define GATT_SEARCH_PACKET 0x1f
#define GATT_SEARCH_PACKET_BACK 0x1f|0x80;

#define GATT_CHECK_GPS_PACKET 0x30
#define GATT_CHECK_GPS_PACKET_BACK 0x30|0x80

#define GATT_DEVICE_VER_PACKET 0x31
#define GATT_DEVICE_VER_PACKET_BACK (0x31|0x80)

#define GATT_DEVICE_MAC_PACKET 0x09
#define GATT_DEVICE_MAC_PACKET_BACK (0x09|0x80)

#define GATT_RESET_PACKET 0x32
#define GATT_RESET_PACKET_BACK 0x32|0x80

#define GATT_Close_PACKET 0x17
#define GATT_Close_PACKET_BACK 0x17|0x80

#define GATT_SPORT_STEP_PACKET_COUNT 0x36
#define GATT_SPORT_STEP_PACKET_COUNT_BACK 0x36|0x80
#define GATT_SPORT_STEP_PACKET 0x37
#define GATT_SPORT_STEP_PACKET_BACK 0x37|0x80

#define GATT_RUN_TIME_PACKET 0x3B
#define GATT_RUN_TIME_PACKET_BACK (0x3B|0x80)

#define GATT_RUN_CLEAN_PACKET (0x15)
#define GATT_RUN_CLEAN_PACKET_BACK (0x15|0x80)

@interface GattPacket : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) UInt8 type;
@property (nonatomic, strong) NSData *content;

-(id)initWithData:(NSData *)charachteristicData error:(NSError **)error;

+(UInt8) calculateVerifyValue:(NSData *)charachteristicData length:(NSInteger)length;

#pragma mark - 生成包

+(GattPacket *)createFlashCleanGatt:(FlashCleanType)cleanType;

+(GattPacket *)createCommonPacketCountGatt:(UInt8)month day:(UInt8)day;
+(GattPacket *)createCommonPacketGatt:(UInt8)month day:(UInt8)day index:(UInt16)index;
+(GattPacket *)createSportPacketCountGatt:(UInt8)month day:(UInt8)day;
+(GattPacket *)createSportPacketGatt:(UInt16)index;
+(GattPacket *)createRunPacketCountGatt:(UInt8)month day:(UInt8)day;
+(GattPacket *)createRunPacketGatt:(UInt16)index;
+(GattPacket *)createRunTimePacketGatt;
// 手环运动步数
+(GattPacket *)createSportStepPacketCountGatt:(UInt8)month day:(UInt8)day;
+(GattPacket *)createSportStepPacketGatt:(UInt8)month day:(UInt8)day index:(UInt16)index;


+(GattPacket *)createBatteryPacketGatt;
+(GattPacket *)createAjustPacketGatt:(NSDateComponents *)date;
+(GattPacket *)createDatePacketGatt;

+(GattPacket *)createFirewareVerPacketGatt;
+(GattPacket *)createFirewareCountPacketGatt:(UInt16)count data:(NSData *)data;
+(GattPacket *)createFirewarePacketGatt:(UInt16)index data:(NSData *)data;

//星历
+(GattPacket *)createAGPSCountPacketGatt:(UInt8)count;
+(GattPacket *)createAGPSPacketGatt:(UInt8)count orderIndex:(UInt8)orderIndex packetIndex:(UInt8)packetIndex data:(NSData *)data;

//查询搜星状态
+ (GattPacket *)createCheckGPSPacketGatt;

//手环模式
+(GattPacket *)createCheckModelPacketGatt;

/**
 寻找手环
 */
+(GattPacket *)createSearchPacketGatt:(BOOL)isStart;

/**
 切换手环模式
 
 @param index 0:普通模式  1：运动模式
 */
+(GattPacket *)createSwitchModelPacketGatt:(UInt8)index;

/**
 硬件版本号
 */
+(GattPacket *)createDeviceVerPacketGatt;

/**
 设备mac地址
 */
+(GattPacket *)createDeviceMacPacketGatt;

// 重启手环
+(GattPacket *)createResetPacketGatt;

// 关闭手环
+(GattPacket *)createClosePacketGatt;

#pragma mark - 解包

+(BOOL)isPacketGattBackData:(NSData *)packetData command:(UInt8)command;

+(NSInteger)parseCommonPacketCountGatt:(NSData *)packetData;
+(NSData *)parseCommonPacketGatt:(NSData *)packetData;

+(NSInteger)parseSportPacketCountGatt:(NSData *)packetData;
+(NSData *)parseSportPacketGatt:(NSData *)packetData;
+(NSInteger)parseSportIndex:(NSData *)packetData;

+(NSInteger)parseRunPacketCountGatt:(NSData *)packetData;
+(NSData *)parseRunPacketGatt:(NSData *)packetData;
+(NSInteger)parseRunIndex:(NSData *)packetData;
//解析跑步开始时间
+(NSDictionary *)parseRunTime:(NSData *)packetData;

// 手环运动步数
+(NSInteger)parseSportStepPacketCountGatt:(NSData *)packetData;
+(NSData *)parseSportStepPacketGatt:(NSData *)packetData;

//返回电量和是否为充电中 0:未充电  1：已充电
+(NSArray<NSNumber *> *)parseBatteryGatt:(NSData *)packetData;
+(NSString *)parserDateGatt:(NSData *)packetData;
+(NSString *)parseFirewareGatt:(NSData *)packetData;

+(NSData *)parseFirewareUpdateGatt:(NSData *)packetData;

//0：success   1：failure
+(NSInteger)parseSearchStartGatt:(NSData *)packetData;

+(BOOL)parseResetPacketGatt:(NSData *)packetData;

+(BOOL)parseClosePacketGatt:(NSData *)packetData;

/**
 解析手环当前模式
 
 @param packetData 手环返回的数据
 @return 0：普通模式   1：运动模式   2：获取失败
 */
+(NSInteger)parseCheckModelGatt:(NSData *)packetData;


/**
 解析手环切换模式
 
 @param packetData 手环返回数据
 @return 0：成功   1：失败
 */
+(NSInteger)parseSwitchModelGatt:(NSData *)packetData;


/**
 解析搜星是否成功
 
 @param packetData 手环返回数据
 @return 0：搜星中   1：搜星成功    2：日常模式，GPS未开启
 */
+ (NSInteger)parseCheckGPSGatt:(NSData *)packetData;

/**
 解析硬件版本
 */
+(NSString *)parseDeviceVerGatt:(NSData *)packetData;

/**
 解析硬件MAC
 */
+(NSString *)parseDeviceMacGatt:(NSData *)packetData;

+ (FlashCleanType)parseCleanFalshGatt:(NSData *)packetData;

+(NSDictionary *)transCommonPacketGatt:(NSData *)packetData;
+(NSDictionary *)transSportPacketGatt:(NSData *)packetData;
+(NSDictionary *)transRunPacketGatt:(NSData *)packetData;
+(NSDictionary *)transSportStepPacketGatt:(NSData *)packetData;

@end

//
//  GattPacket.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/19.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PACKET_HEAD 0xa5
#define PACKET_BACK 0x80
#define SEARCHSTAR_HEAD 0xa6
#define UPDATE_WRITE_HEAD 0xa7
#define UPDATE_BACK_HEAD 0xa8
#define Invalid_Commond  0xfe

#define GATT_COMMON_PACKET_COUNT 0x01
#define GATT_COMMON_PACKET_COUNT_BACK (0x01|0x80)
#define GATT_COMMON_PACKET 0x02
#define GATT_COMMON_PACKET_BACK (0x02|0x80)

#define GATT_SPORT_PACKET_COUNT 0x03
#define GATT_SPORT_PACKET_COUNT_BACK (0x03|0x80)
#define GATT_SPORT_PACKET 0x04
#define GATT_SPORT_PACKET_BACK (0x04|0x80)

#define GATT_SWITCH_MODEL_PACKET 0x07
#define GATT_SWITCH_MODEL_PACKET_BACK (0x07|0x80)

#define GATT_DATE_PACKET 0x0b
#define GATT_DATE_PACKET_BACK (0x0b|0x80)

#define GATT_ADJUST_PACKET 0x0c
#define GATT_ADJUST_PACKET_BACK (0x0c|0x80)

#define GATT_BATTERY_PACKET 0x0d
#define GATT_BATTERY_PACKET_BACK (0x0d|0x80)

#define GATT_FIREWARE_VER_PACKET 0x0f
#define GATT_FIREWARE_VER_PACKET_BACK (0x0f|0x80)

#define GATT_CLICK_DEVICE_PACKET 0x13

#define GATT_FIREWARE_COUNT_PACKET 0x14
#define GATT_FIREWARE_COUNT_PACKET_BACK (0x14|0x80)

#define GATT_SEARCH_PACKET 0x1f
#define GATT_SEARCH_PACKET_BACK (0x1f|0x80)

#define GATT_CHECK_MODEL_PACKET 0x22
#define GATT_CHECK_MODEL_PACKET_BACK (0x22|0x80)

#define GATT_AGPS_COUNT_PACKET 0x24
#define GATT_AGPS_COUNT_PACKET_BACK (0x24|0x80)

#define GATT_CHECK_GPS_PACKET 0x30
#define GATT_CHECK_GPS_PACKET_BACK (0x30|0x80)

#define GATT_DEVICE_VER_PACKET 0x31
#define GATT_DEVICE_VER_PACKET_BACK (0x31|0x80)

#define GATT_RESET_PACKET 0x32;
#define GATT_RESET_PACKET_BACK 0x32|0x80;

#define GATT_READ_FIX_INFO_PACK 0x33
#define GATT_READ_FIX_INFO_PACK_BACK (0x33|0x80)

#define GATT_READ_VARIABLE_INFO_PACK 0x34
#define GATT_READ_VARIABLE_INFO_PACK_BACK (0x34|0x80)

@interface GattPacket : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) UInt8 head;
@property (nonatomic, assign) UInt8 type;
@property (nonatomic, strong) NSData *content;
    
-(id)initWithData:(NSData *)charachteristicData error:(NSError **)error;

#pragma mark - 生成包
+(GattPacket *)createCommonPacketCountGatt:(UInt8)month day:(UInt8)day;
+(GattPacket *)createCommonPacketGatt:(UInt8)month day:(UInt8)day index:(UInt16)index;
+(GattPacket *)createSportPacketCountGatt:(UInt8)month day:(UInt8)day;
+(GattPacket *)createSportPacketGatt:(UInt16)index;
    
+(GattPacket *)createBatteryPacketGatt;
+(GattPacket *)createAjustPacketGatt:(NSDate *)date;
+(GattPacket *)createDatePacketGatt;
    
+(GattPacket *)createFirewareVerPacketGatt;
+(GattPacket *)createFirewareCountPacketGatt:(UInt16)count data:(NSData *)data;
+(GattPacket *)createFirewarePacketGatt:(UInt16)index data:(NSData *)data;
    
//星历
+(GattPacket *)createAGPSCountPacketGatt:(UInt8)count;
+(GattPacket *)createAGPSPacketGatt:(UInt8)count orderIndex:(UInt8)orderIndex packetIndex:(UInt8)packetIndex data:(NSData *)data;
    
//查询搜星状态
+(GattPacket *)createCheckGPSPacketGatt;
    
//手环模式
+(GattPacket *)createCheckModelPacketGatt;
    
/**
寻找手环
*/
+(GattPacket *)createSearchPacketGatt:(UInt8)state;
    
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
 生成重启手环的包
 */
+(GattPacket *)createResetPacketGatt;

/**
 生成读取手环固定信息包
 */
+(GattPacket *)createFixInfoPacketGatt;

/**
 生成读取手环可变信息包
 */
+(GattPacket *)createVariableInfoPacketGatt;
    
#pragma mark - 解包
    
+(NSInteger)parseCommonPacketCountGatt:(NSData *)packetData;
+(NSInteger)parseSportPacketCountGatt:(NSData *)packetData;
    
+(NSData *)parseCommonPacketGatt:(NSData *)packetData;
+(NSData *)parseSportPacketGatt:(NSData *)packetData;
+(NSInteger)parseSportIndex:(NSData *)packetData;
    
+(NSInteger)parseBatteryGatt:(NSData *)packetData;
+(NSInteger)parseAdjustDataGatt:(NSData *)packetData;
+(NSDate *)parseDeviceDateGatt:(NSData *)packetData;
+(NSString *)parseFirewareVerGatt:(NSData *)packetData;
    
+(NSData *)parseFirewareUpdateGatt:(NSData *)packetData;
    
//0：success   1：failure
+(NSInteger)parseSearchStartGatt:(NSData *)packetData;
    
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
+(NSInteger)parseCheckGPSGatt:(NSData *)packetData;

/**
 解析硬件版本
 */
+(NSString *)parseDeviceVerGatt:(NSData *)packetData;

/**
 解析手环重启是否成功

 @param packetData 手环返回数据
 @return YES：成功   NO：失败
 */
+ (BOOL)parseResetPacketGatt:(NSData *)packetData;

/**
 解析手环固定信息

 @param packetData 手环返回数据
 @return 包含是手环日期、固件版本号、硬件版本号
 */
+ (NSArray<NSString *> *)parseFixInfoPacketGatt:(NSData *)packetData;

/**
 解析手环可变信息

 @param packetData 手环返回数据
 @return 包含电量、是否充电、定位是否成功和开启，开机次数
 */
+ (NSArray<NSString *> *)parseVariableInfoPacketGatt:(NSData *)packetData;


/**
 解析设备点击
 */
+(NSInteger)parseDeviceClickGatt:(NSData *)packetData;
    
// 数据解析
+(NSDictionary *)transCommonPacketGatt:(NSData *)packetData;
+(NSDictionary *)transSportPacketGatt:(NSData *)packetData;

#pragma mark - 其它操作
+(BOOL)isDeviceActive:(GattPacket *)gattPacket;
    
@end

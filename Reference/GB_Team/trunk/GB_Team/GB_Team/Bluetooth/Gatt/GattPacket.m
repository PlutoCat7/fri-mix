//
//  GattPacket.m
//  GB_Football
//
//  Created by weilai on 16/3/9.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GattPacket.h"
#import "BleGlobal.h"

@implementation GattPacket

-(id)initWithData:(NSData *)charachteristicData error:(NSError **)error
{
    if (self = [super init]) {
        if (charachteristicData == nil || [charachteristicData length] < 3 || [self checkCharachteristicData:charachteristicData] == NO) {
            *error = makeError(GattErrors_InvalidArgument, LS(@""));
            return self;
        }
        
        self.data = [NSData dataWithData:charachteristicData];
        UInt8 headByte;
        [charachteristicData getBytes:&headByte length:1];
        if (headByte == UPDATE_HEAD || headByte == SEARCHSTAR_HEAD) {
            self.type = headByte;
            self.content = [NSData dataWithData:charachteristicData];
            
        } else {
            // 长度判断
            UInt8 lengthByte;
            [charachteristicData getBytes:&lengthByte range:NSMakeRange(1, 1)];
            
            // 指令类型
            UInt8 type;
            [charachteristicData getBytes:&type range:NSMakeRange(2, 1)];
            self.type = type;
            
            self.content = [charachteristicData subdataWithRange:NSMakeRange(3, (lengthByte - 4))];
        }
        
    }
    
    return self;
}

-(BOOL) checkCharachteristicData:(NSData *)charachteristicData
{
    if (charachteristicData == nil || [charachteristicData length] < 3) {
        return NO;
    }
    
    // 判断头信息
    UInt8 headByte;
    [charachteristicData getBytes:&headByte length:1];
    if (headByte == UPDATE_HEAD && [charachteristicData length] == 4) {
        return YES;
        
    }else if (headByte == SEARCHSTAR_HEAD && [charachteristicData length] == 4) {
        return YES;
        
    } else if (headByte != PACKET_HEAD) {
        if (headByte == Invalid_Commond) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Bluetooth_Invalid_Command object:nil];
        }
        return NO;
    }
    
    // 长度判断
    UInt8 lengthByte;
    [charachteristicData getBytes:&lengthByte range:NSMakeRange(1, 1)];
    if ([charachteristicData length] < lengthByte) {
        return NO;
    }
    
    UInt8 verity;
    [charachteristicData getBytes:&verity range:NSMakeRange(lengthByte - 1, 1)];
    if (verity != [GattPacket calculateVerifyValue:charachteristicData length:(lengthByte - 1)]) {
        return NO;
    }
    
    return YES;
}

+(UInt8) calculateVerifyValue:(NSData *)charachteristicData length:(NSInteger)length
{
    if ([charachteristicData length] < length) {
        return 0;
    }
    
    Byte *bytes = (Byte *)[charachteristicData bytes];
    UInt8 verity = '\0';
    for (int i = 0; i < length; i++) {
        if (i == 0) {
            verity = bytes[i];
            
        } else {
            verity = verity ^ bytes[i];
        }
        
    }
    return verity;
}

// 创建普通拆包数
+(GattPacket *)createCommonPacketCountGatt:(UInt8)month day:(UInt8)day
{
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_COMMON_PACKET_COUNT;
    
    Byte byte[2] = {month, day};
    gattPacket.content = [[NSData alloc] initWithBytes:byte length:2];
    
    Byte dataByte[7] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 7;
    dataByte[2] = GATT_COMMON_PACKET_COUNT;
    dataByte[3] = month;
    dataByte[4] = day;
    dataByte[5] = 0x01;
    dataByte[6] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:6] length:6];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:7];
    return gattPacket;
    
}

+(GattPacket *)createCommonPacketGatt:(UInt8)month day:(UInt8)day index:(UInt16)index
{
    UInt8 lowByte = 0xff & index;
    UInt8 heightByte = 0xff & (index >> 8);
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_COMMON_PACKET;
    
    Byte byte[4] = {month, day, lowByte, heightByte};
    gattPacket.content = [[NSData alloc] initWithBytes:byte length:4];
    
    Byte dataByte[8] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 8;
    dataByte[2] = GATT_COMMON_PACKET;
    dataByte[3] = month;
    dataByte[4] = day;
    dataByte[5] = lowByte;
    dataByte[6] = heightByte;
    dataByte[7] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:7] length:7];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:8];
    return gattPacket;
}

+(GattPacket *)createSportPacketCountGatt:(UInt8)month day:(UInt8)day
{
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_SPORT_PACKET_COUNT;
    
    Byte byte[2] = {month, day};
    gattPacket.content = [[NSData alloc] initWithBytes:byte length:2];
    
    Byte dataByte[7] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 7;
    dataByte[2] = GATT_SPORT_PACKET_COUNT;
    dataByte[3] = month;
    dataByte[4] = day;
    dataByte[5] = 0x01;
    dataByte[6] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:6] length:6];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:7];
    return gattPacket;
}

+(GattPacket *)createSportPacketGatt:(UInt16)index
{
    UInt8 lowByte = 0xff & index;
    UInt8 heightByte = 0xff & (index >> 8);
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_SPORT_PACKET;
    
    Byte byte[2] = {lowByte, heightByte};
    gattPacket.content = [[NSData alloc] initWithBytes:byte length:2];
    
    Byte dataByte[6] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 6;
    dataByte[2] = GATT_SPORT_PACKET;
    dataByte[3] = lowByte;
    dataByte[4] = heightByte;
    dataByte[5] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:5] length:5];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:6];
    return gattPacket;
}

+ (GattPacket *)createBatteryPacketGatt
{
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_BATTERY_PACKET;
    
    Byte dataByte[4] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x04;
    dataByte[2] = GATT_BATTERY_PACKET;
    dataByte[3] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:3] length:3];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

+(GattPacket *)createAjustPacketGatt:(NSDate *)date
{
    UInt8 year,month,day,hour,minute,second = 0;
    if (date) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [cal components:unitFlags fromDate:date];
        
        year = (UInt8)([dateComponent year] - 2000);
        month = (UInt8)[dateComponent month];
        day = (UInt8)[dateComponent day];
        hour = (UInt8)[dateComponent hour];
        minute = (UInt8)[dateComponent minute];
        second = (UInt8)[dateComponent second];
    }
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_ADJUST_PACKET;
    
    Byte dataByte[10] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x0a;
    dataByte[2] = GATT_ADJUST_PACKET;
    dataByte[3] = year;
    dataByte[4] = month;
    dataByte[5] = day;
    dataByte[6] = hour;
    dataByte[7] = minute;
    dataByte[8] = second;
    dataByte[9] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:9] length:9];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:10];
    
    return gattPacket;
}

+(GattPacket *)createDatePacketGatt
{
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_DATE_PACKET;
    
    Byte dataByte[4] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x04;
    dataByte[2] = GATT_DATE_PACKET;
    dataByte[3] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:3] length:3];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

+(GattPacket *)createFirewareVerPacketGatt
{
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_FIREWARE_PACKET;
    
    Byte dataByte[4] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x04;
    dataByte[2] = GATT_FIREWARE_PACKET;
    dataByte[3] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:3] length:3];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

+(GattPacket *)createFirewareCountPacketGatt:(UInt16)count data:(NSData *)data
{
    UInt8 lowByte = 0xff & count;
    UInt8 heightByte = 0xff & (count >> 8);
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_FIREWARE_COUNT_PACKET;
    
    Byte *bytes = (Byte *)[data bytes];
    UInt32 byteSum = '\0';
    for (int i = 0; i < data.length; i++) {
        byteSum += bytes[i];
    }
    
    Byte dataByte[9] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x09;
    dataByte[2] = GATT_FIREWARE_COUNT_PACKET;
    dataByte[3] = lowByte;
    dataByte[4] = heightByte;
    //    dataByte[5] = 0x00;
    //    dataByte[6] = 0x00;
    //    dataByte[7] = 0x00;
    dataByte[5] = byteSum & 0xff;
    dataByte[6] = (byteSum >> 8) & 0xff;
    dataByte[7] = (byteSum >> 16) & 0xff;
    dataByte[8] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:8] length:8];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:9];
    
    return gattPacket;
}

+(GattPacket *)createFirewarePacketGatt:(UInt16)index data:(NSData *)data
{
    UInt8 lowByte = 0xff & index;
    UInt8 heightByte = 0xff & (index >> 8);
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_FIREWARE_COUNT_PACKET;
    
    NSMutableData *gattData = [NSMutableData new];
    
    Byte dataByte[3] = {0};
    dataByte[0] = 0xa7;
    dataByte[1] = lowByte;
    dataByte[2] = heightByte;
    
    [gattData appendBytes:dataByte length:3];
    [gattData appendBytes:data.bytes length:data.length];
    
    Byte checkByte[1] = {0};
    checkByte[0] = [GattPacket calculateVerifyValue:gattData length:gattData.length];
    [gattData appendBytes:checkByte length:1];
    
    gattPacket.data = [[NSData alloc] initWithData:gattData];
    
    return gattPacket;
}

+(GattPacket *)createAGPSCountPacketGatt:(UInt8)count {
    
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_AGPS_COUNT_PACKET;
    
    Byte dataByte[5] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x05;
    dataByte[2] = GATT_AGPS_COUNT_PACKET;
    dataByte[3] = count;
    dataByte[4] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:4] length:4];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

+(GattPacket *)createAGPSPacketGatt:(UInt8)count orderIndex:(UInt8)orderIndex packetIndex:(UInt8)packetIndex data:(NSData *)data {
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = 0xa6;
    
    NSMutableData *gattData = [NSMutableData new];
    
    Byte dataByte[4] = {0};
    dataByte[0] = 0xa6;
    dataByte[1] = orderIndex;
    dataByte[2] = count;
    dataByte[3] = packetIndex;
    
    [gattData appendBytes:dataByte length:4];
    [gattData appendBytes:data.bytes length:data.length];
    
    Byte checkByte[1] = {0};
    checkByte[0] = [GattPacket calculateVerifyValue:gattData length:gattData.length];
    [gattData appendBytes:checkByte length:1];
    
    gattPacket.data = [[NSData alloc] initWithData:gattData];
    
    return gattPacket;
}

+ (GattPacket *)createCheckGPSPacketGatt {
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_CHECK_GPS_PACKET;
    
    Byte dataByte[4] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x04;
    dataByte[2] = GATT_CHECK_GPS_PACKET;
    dataByte[3] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:3] length:3];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

+(GattPacket *)createCheckModelPacketGatt {
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_CHECK_MODEL_PACKET;
    
    Byte dataByte[4] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x04;
    dataByte[2] = GATT_CHECK_MODEL_PACKET;
    dataByte[3] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:3] length:3];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

+(GattPacket *)createSearchPacketGatt:(BOOL)isStart {
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_SEARCH_PACKET;
    
    Byte dataByte[5] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x05;
    dataByte[2] = GATT_SEARCH_PACKET;
    dataByte[3] = isStart?0x01:0x00;
    dataByte[4] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:4] length:4];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:5];
    
    return gattPacket;
}

+ (GattPacket *)createSwitchModelPacketGatt:(UInt8)index {
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_SWITCH_MODEL_PACKET;
    
    Byte dataByte[5] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x05;
    dataByte[2] = GATT_SWITCH_MODEL_PACKET;
    dataByte[3] = index;
    dataByte[4] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:4] length:4];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:5];
    
    return gattPacket;
}

+ (GattPacket *)createDeviceVerPacketGatt {
    
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_DEVICE_VER_PACKET;
    
    Byte dataByte[4] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x04;
    dataByte[2] = GATT_DEVICE_VER_PACKET;
    dataByte[3] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:3] length:3];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

// 重启手环
+(GattPacket *)createResetPacketGatt
{
    GattPacket *gattPacket = [[GattPacket alloc] init];
    gattPacket.type = GATT_RESET_PACKET;
    
    Byte dataByte[4] = {0};
    dataByte[0] = PACKET_HEAD;
    dataByte[1] = 0x04;
    dataByte[2] = GATT_RESET_PACKET;
    dataByte[3] = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:dataByte length:3] length:3];
    
    gattPacket.data = [[NSData alloc] initWithBytes:dataByte length:4];
    
    return gattPacket;
}

+(BOOL)isPacketGattBackData:(NSData *)packetData command:(UInt8)command;
{
    if (packetData && packetData.length > 4) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 length = bytes[1];
        UInt8 reCommand = bytes[2];
        UInt8 baCommand = command | 0x80;
        if (length > packetData.length || (baCommand ^ reCommand) != 0x00) {
            return NO;
        }
        
        UInt8 verify = [GattPacket calculateVerifyValue:[[NSData alloc] initWithBytes:bytes length:(length - 1)] length:(length - 1)];
        if ((verify ^ bytes[length - 1]) != 0x00) {
            return NO;
        }
        
        return YES;
        
    }
    
    return NO;
}


+(NSInteger)parseCommonPacketCountGatt:(NSData *)packetData
{
    if (packetData && packetData.length >= 6) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 height = bytes[4];
        UInt8 low = bytes[3];
        return ((height << 8) | low);
    }
    return 0;
}

+(NSInteger)parseSportPacketCountGatt:(NSData *)packetData
{
    if (packetData && packetData.length >= 6) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 height = bytes[4];
        UInt8 low = bytes[3];
        return ((height << 8) | low);
    }
    return 0;
}

+(NSData *)parseCommonPacketGatt:(NSData *)packetData
{
    if (packetData && packetData.length > 5) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 length = bytes[1];
        NSData *parserData = [packetData subdataWithRange:NSMakeRange(5, (length - 6))];
        return parserData;
    }
    
    return nil;
}

+(NSData *)parseSportPacketGatt:(NSData *)packetData
{
    if (packetData && packetData.length > 5) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 length = bytes[1];
        NSData *parserData = [packetData subdataWithRange:NSMakeRange(5, (length - 6))];
        return parserData;
    }
    
    return nil;
}

+(NSInteger)parseSportIndex:(NSData *)packetData
{
    if (packetData && packetData.length > 5) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt16 index = bytes[3] | (bytes[4] << 8);
        return index;
    }
    
    return -1;
}

+(NSInteger)parseBatteryGatt:(NSData *)packetData
{
    if (packetData && packetData.length == 6) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 battery = bytes[3];
        return battery;
    }
    return 0;
}

+(NSString *)parserDateGatt:(NSData *)packetData
{
    if (packetData && packetData.length == 10) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 yearByte = bytes[3];
        UInt8 monthByte = bytes[4];
        UInt8 dayByte = bytes[5];
        //        UInt8 hourByte = bytes[6];
        //        UInt8 minuteByte = bytes[7];
        //        UInt8 secondByte = bytes[8];
        
        NSString *dateStr = [NSString stringWithFormat:@"%d-%02d-%02d", (2000 + yearByte), monthByte, dayByte];
        return dateStr;
    }
    return nil;
}

+(NSString *)parseFirewareGatt:(NSData *)packetData
{
    if (packetData && packetData.length == 8) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 oneByte = bytes[3];
        UInt8 pointByte = bytes[4];
        UInt8 pOneByte = bytes[5];
        UInt8 pTwoByte = bytes[6];
        
        NSString *result = [NSString stringWithFormat:@"%c%c%c%c", oneByte, pointByte, pOneByte, pTwoByte];
        
        return result;
    }
    return nil;
}

+(NSData *)parseFirewareUpdateGatt:(NSData *)packetData
{
    if (packetData && packetData.length > 2) {
        NSData *parserData = [packetData subdataWithRange:NSMakeRange(1, packetData.length - 2)];
        return parserData;
    }
    
    return nil;
}

+(NSInteger)parseSearchStartGatt:(NSData *)packetData {
    
    if (packetData && packetData.length == 4) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 code = bytes[2];
        return code;
    }
    return 1;
}

+(NSInteger)parseCheckModelGatt:(NSData *)packetData {
    
    if (packetData && packetData.length == 5) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 code = bytes[3];
        return code;
    }
    return 2;
}

+(NSInteger)parseSwitchModelGatt:(NSData *)packetData {
    
    if (packetData && packetData.length == 5) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 code = bytes[3];
        return code;
    }
    return 1;
}

+ (NSInteger)parseCheckGPSGatt:(NSData *)packetData {
    
    if (packetData && packetData.length == 5) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 code = bytes[3];
        return code;
    }
    return 2;
}

+ (NSString *)parseDeviceVerGatt:(NSData *)packetData {
    if (packetData && packetData.length == 8) {
        Byte *bytes = (Byte *)[packetData bytes];
        UInt8 oneByte = bytes[3];
        UInt8 pointByte = bytes[4];
        UInt8 pOneByte = bytes[5];
        UInt8 pTwoByte = bytes[6];
        
        NSString *result = [NSString stringWithFormat:@"%c%c%c%c", oneByte, pointByte, pOneByte, pTwoByte];
        
        return result;
    }
    return nil;
}

+(BOOL)parseResetPacketGatt:(NSData *)packetData
{
    if (packetData && packetData.length == 4) {
        return YES;
    }
    return NO;
}

+(NSDictionary *)transCommonPacketGatt:(NSData *)packetData
{
    if (packetData && packetData.length > 3) {
        Byte *baseBytes = (Byte *)[[packetData subdataWithRange:NSMakeRange(0, 3)] bytes];
        UInt8 month = baseBytes[0];
        UInt8 day = baseBytes[1];
        UInt8 flag = (baseBytes[2] == 0x01) ? 0x05 : 0x05;//默认0x01是5分钟
        flag = (baseBytes[2] == 0x02) ? 0x01 : flag;//默认0x02是1分钟
        
        int start = 3;
        NSMutableArray *itemArray = [NSMutableArray new];
        while (start < packetData.length) {
            if (start + 4 > packetData.length) {
                break;
            }
            Byte *itemDayBytes = (Byte *)[[packetData subdataWithRange:NSMakeRange(start, 4)] bytes];
            UInt8 hour = itemDayBytes[0];
            UInt8 minute = itemDayBytes[1];
            UInt16 timeInv = itemDayBytes[2] + (itemDayBytes[3] << 8);
            
            start += 4;
            int count = timeInv / flag + ((timeInv % flag) == 0 ? 0 : 1);
            int length = 2 * count;
            if (start + length > packetData.length) {
                break;
            }
            
            Byte *itemBytes = (Byte *)[[packetData subdataWithRange:NSMakeRange(start, length)] bytes];
            NSMutableArray *stepArray = [NSMutableArray new];
            for (int index = 0; index < count; index++) {
                UInt16 step = itemBytes[index * 2] + (itemBytes[index * 2 + 1] << 8);
                step = (step > 300) ? 30 : step;
                [stepArray addObject:[NSNumber numberWithUnsignedInt:step]];
            }
            
            start += length;
            
            NSMutableDictionary *itemDict = [NSMutableDictionary new];
            [itemDict setObject:[NSNumber numberWithUnsignedInt:hour] forKey:@"hour"];
            [itemDict setObject:[NSNumber numberWithUnsignedInt:minute] forKey:@"minute"];
            [itemDict setObject:[NSNumber numberWithUnsignedInt:timeInv] forKey:@"duration"];
            [itemDict setObject:stepArray forKey:@"steps"];
            
            [itemArray addObject:itemDict];
            
        }
        
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        [dataDict setObject:[NSNumber numberWithUnsignedInt:month] forKey:@"month"];
        [dataDict setObject:[NSNumber numberWithUnsignedInt:day] forKey:@"day"];
        [dataDict setObject:[NSNumber numberWithUnsignedInt:flag] forKey:@"interval"];
        [dataDict setObject:itemArray forKey:@"items"];
        
        return  dataDict;
    }
    return nil;
}

+(NSDictionary *)transSportPacketGatt:(NSData *)packetData
{
    // 判断条件为13，需要有基本的月日时分秒（5位）＋经度（4位）＋纬度（4位）
    if (packetData && packetData.length >= 13) {
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        
        Byte *baseBytes = (Byte *)[[packetData subdataWithRange:NSMakeRange(0, 13)] bytes];
        UInt8 month = baseBytes[0];
        UInt8 day = baseBytes[1];
        UInt8 hour = baseBytes[2];
        UInt8 minute = baseBytes[3];
        UInt8 second = baseBytes[4];
        UInt32 longitude = baseBytes[5] + (baseBytes[6] << 8) + (baseBytes[7] << 16) + (baseBytes[8] << 24);
        UInt32 latitude = baseBytes[9] + (baseBytes[10] << 8) + (baseBytes[11] << 16) + (baseBytes[12] << 24);
        
        [dataDict setObject:[NSNumber numberWithInt:month] forKey:@"month"];
        [dataDict setObject:[NSNumber numberWithInt:day] forKey:@"day"];
        [dataDict setObject:[NSNumber numberWithInt:hour] forKey:@"hour"];
        [dataDict setObject:[NSNumber numberWithInt:minute] forKey:@"minute"];
        [dataDict setObject:[NSNumber numberWithInt:second] forKey:@"second"];
        [dataDict setObject:[NSNumber numberWithLong:longitude] forKey:@"start_longitude"];
        [dataDict setObject:[NSNumber numberWithLong:latitude] forKey:@"start_latitude"];
        
        int start = 13;
        NSMutableArray *itemArray = [NSMutableArray new];
        for (int i = 0; (start + (i + 1) * 8) < packetData.length; i++) {
            Byte *itemByte = (Byte *)[[packetData subdataWithRange:NSMakeRange((start + i * 8), 8)] bytes];
            UInt16 invSec = itemByte[0] + (itemByte[1] << 8);
            int16_t invLon = itemByte[2] + (itemByte[3] << 8);
            int16_t invLat = itemByte[4] + (itemByte[5] << 8);
            UInt8 step = itemByte[6];
            UInt8 speed = itemByte[7];
            
            NSMutableDictionary *itemDict = [NSMutableDictionary new];
            [itemDict setObject:[NSNumber numberWithInt:invSec] forKey:@"interval_time"];
            [itemDict setObject:[NSNumber numberWithInt:invLon] forKey:@"interval_longitude"];
            [itemDict setObject:[NSNumber numberWithInt:invLat] forKey:@"interval_latitude"];
            [itemDict setObject:[NSNumber numberWithInt:step] forKey:@"step_number"];
            [itemDict setObject:[NSNumber numberWithInt:speed] forKey:@"speed"];
            
            [itemArray addObject:itemDict];
        }
        [dataDict setObject:itemArray forKey:@"items"];
        
        return  dataDict;
    }
    return nil;
}


@end

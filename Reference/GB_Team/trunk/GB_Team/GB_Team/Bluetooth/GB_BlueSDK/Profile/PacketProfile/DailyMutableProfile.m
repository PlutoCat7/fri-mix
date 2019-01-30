//
//  DailyMutableProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/28.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "DailyMutableProfile.h"

// 发送数据的扩展
@interface PacketProfile(DailyExtend)

- (void)sendPacket:(GattPacket *)gattPacket;
- (void)resetResponseTimeOver;
- (void)closeResponseTimeOver;
@end

@interface DailyMutableProfile()

@property (nonatomic, strong) NSMutableData *dailyData;
@property (nonatomic, strong) NSMutableData *allDailyData;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *resultData;

@property (nonatomic, strong) NSArray<NSDate *> *dateArray;
@property (nonatomic, strong) NSDate *curDate;
@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger readCount;

@end

@implementation DailyMutableProfile

- (instancetype)initWithMultiDate:(NSArray<NSDate *> *)dateArray {
    if (self = [super init]) {
        _dateArray = dateArray;
        _curIndex = 0;
        _resultData = [NSMutableDictionary dictionaryWithCapacity:1];
        _allDailyData = [NSMutableData new];
    }
    
    return self;
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [self createCurrentCountPacketGatt];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return (packet.head == PACKET_HEAD && packet.type == GATT_COMMON_PACKET_COUNT_BACK) || (packet.head == PACKET_HEAD && packet.type == GATT_COMMON_PACKET_BACK);
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (packet.head == PACKET_HEAD && packet.type == GATT_COMMON_PACKET_COUNT_BACK) {
        self.totalCount = [GattPacket parseCommonPacketCountGatt:packet.data];
        if (self.totalCount == 0) { //当前日期没有日常数据，读取下个日期
            // 读下一个
            [self readNextDateData];
        } else {//读取当前日常数据
            [self sendDailyData];
        }
        
    } else if (packet.head == PACKET_HEAD && packet.type == GATT_COMMON_PACKET_BACK) {
        // 解析数据
        NSData *paserData = [GattPacket parseCommonPacketGatt:packet.data];
        if (paserData) {
            [self.dailyData appendData:paserData];
            self.readCount++;
            if (self.readCount == self.totalCount) {//当前日期数据已读完
                // 把数据加入所有原始数据里
                [self.allDailyData appendData:self.dailyData];
                
                // 解析数据
                NSDictionary *dataDict = [GattPacket transCommonPacketGatt:self.dailyData];
                if (dataDict && self.curDate) {
                    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
                    [dateToStrFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *YMD = [dateToStrFormatter stringFromDate:self.curDate];
                    
                    [self.resultData setObject:dataDict forKey:YMD];
                }
                
                // 读下一个
                [self readNextDateData];
                
            } else {
                // 重置定时器
                [self resetResponseTimeOver];
            }
        }
    }
}

- (BOOL)isEqualProfile:(id)packetProfile {
    if (![packetProfile isMemberOfClass:[self class]]) {
        return NO;
    }
    
    if (self.dateArray.count != ((DailyMutableProfile *) packetProfile).dateArray.count) {
        return NO;
    }
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (NSInteger index = [self.dateArray count]-1; index >= 0; index--) {
        NSDate *date = self.dateArray[index];
        NSDate *pDate = ((DailyMutableProfile *) packetProfile).dateArray[index];
        
        NSString *YMD = [dateToStrFormatter stringFromDate:date];
        NSString *pYMD = [dateToStrFormatter stringFromDate:pDate];
        if (![YMD isEqualToString:pYMD]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Private

-(void)sendDailyData {
    GattPacket *gattPacket = [self createCurrentDataPacketGatt];
    if (gattPacket == nil) {
        [self closeResponseTimeOver];
        
        BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [NSError errorWithDomain:@"read daily data fail." code:GattErrors_PaserFail userInfo:nil]);
        return;
    }

    [self sendPacket:gattPacket];
}

- (GattPacket *)createCurrentDataPacketGatt {
    if (self.curDate == nil) {
        return nil;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [cal components:unitFlags fromDate:self.curDate];
    NSInteger sMonth = [dateComponent month];
    NSInteger sDay = [dateComponent day];
    
    GattPacket *gattPacket = [GattPacket createCommonPacketGatt:sMonth day:sDay index:0];
    return gattPacket;
}

- (void)readNextDateData {
    
    self.curIndex++;
    GattPacket *nextPacket = [self createCurrentCountPacketGatt];
    if (nextPacket == nil) {
        BLE_BLOCK_EXEC(self.serviceBlock, self.resultData, self.allDailyData, nil);
    } else {
        [self sendPacket:nextPacket];
    }
}

- (GattPacket *)createCurrentCountPacketGatt {
    
    if (self.curIndex >= [self.dateArray count]) {
        return nil;
    }
    self.curDate = self.dateArray[self.curIndex];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [cal components:unitFlags fromDate:self.curDate];
    NSInteger sMonth = [dateComponent month];
    NSInteger sDay = [dateComponent day];
    
    self.totalCount = 0;
    self.readCount = 0;
    self.dailyData = [[NSMutableData alloc] init];
    
    GattPacket *countGattPacket = [GattPacket createCommonPacketCountGatt:sMonth day:sDay];
    return countGattPacket;
}

@end

//
//  SportProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/29.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "SportProfile.h"

// 发送数据的扩展
@interface PacketProfile(SportExtend)

- (void)sendPacket:(GattPacket *)gattPacket;
- (void)resetResponseTimeOver;
- (void)closeResponseTimeOver;
@end

@interface SportProfile()

@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, strong) NSMutableData *sportData;
@property (nonatomic, strong) NSMutableData *sourceData;

@end

@implementation SportProfile

- (instancetype)initWithDate:(NSInteger)month day:(NSInteger)day {
    if (self = [super init]) {
        _month = month;
        _day = day;
    }
    return self;
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createSportPacketCountGatt:self.month day:self.day];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return (packet.head == PACKET_HEAD && packet.type == GATT_SPORT_PACKET_COUNT_BACK) || (packet.head == PACKET_HEAD && packet.type == GATT_SPORT_PACKET_BACK);
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    self.totalCount = 0;
    self.readCount = 0;
    self.sportData = [[NSMutableData alloc] init];
    self.sourceData = [[NSMutableData alloc] init];
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (packet.head == PACKET_HEAD && packet.type == GATT_SPORT_PACKET_COUNT_BACK) {
        self.totalCount = [GattPacket parseSportPacketCountGatt:packet.data];
        if (self.totalCount == 0) { //当前手环没有数据
            BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [NSError errorWithDomain:@"read sport data empty." code:GattErrors_EmptyData userInfo:nil]);
            
        } else {//读取数据
            GattPacket *gattPacket = [GattPacket createSportPacketGatt:0];
            [self sendPacket:gattPacket];
            
        }
        
    } else if (packet.head == PACKET_HEAD && packet.type == GATT_SPORT_PACKET_BACK) {
        // 保存原始数据
        [self.sourceData appendData:packet.data];
        
        NSData *paserData = [GattPacket parseSportPacketGatt:packet.data];
        NSInteger index = [GattPacket parseSportIndex:packet.data];
        
        if (paserData && index == self.readCount + 1) {
            [self.sportData appendData:paserData];
            
            self.readCount++;
            if (self.readCount == self.totalCount) {
                [self closeResponseTimeOver];
                
                NSDictionary *dataDict = [GattPacket transSportPacketGatt:self.sportData];
                if (dataDict && self.serviceBlock) {
                    BLE_BLOCK_EXEC(self.serviceBlock, dataDict, self.sourceData, nil);
                } else {
                    BLE_BLOCK_EXEC(self.serviceBlock, nil, self.sourceData, [NSError errorWithDomain:@"read sport data fail." code:GattErrors_PaserFail userInfo:nil]);
                }
                
            } else {
                // 重置定时器
                [self resetResponseTimeOver];
                
                BLE_BLOCK_EXEC(self.progressBlock, self.totalCount, self.readCount);
            }
        }
    }
}

- (BOOL)isEqualProfile:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    if (self.month == ((SportProfile *)object).month && self.day == ((SportProfile *)object).day) {
        return NO;
    }
    return YES;
}

@end

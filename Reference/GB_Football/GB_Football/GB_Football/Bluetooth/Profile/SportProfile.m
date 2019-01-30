//
//  SportProfile.m
//  GB_Football
//
//  Created by weilai on 16/3/20.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "SportProfile.h"

@interface SportProfile() <PacketProfileDelegate>
{

    NSInteger totalCount;
    NSInteger readCount;
    
    NSMutableData *sportData;
    NSMutableData *sourceData;
}

@property (nonatomic, copy) ReadProgressBlock progressBlock;
@property (nonatomic, copy) ReadMultiServiceBlock serviceBlock;

@property (nonatomic, strong) NSTimer *readTimer;

@end

@implementation SportProfile

#pragma mark - OverWrite

- (void)stopTask {
    
    [super stopTask];
    [self closeReadTimer];
}

#pragma mark - Public

- (void)sendSportProfile:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock {
    
    [self reset];
    self.progressBlock = progressBlock;
    self.serviceBlock = serviceBlock;
    
    GattPacket *countGattPacket = [GattPacket createSportPacketCountGatt:month day:day];
    [self sendPacket:countGattPacket];
    
    [self resetReadTimer];
}

#pragma mark - PacketProfileDelegate

- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive) {
        return;
    }
    if (packet.type == (0x03|0x80)) {
        [self resetReadTimer];
        
        totalCount = [GattPacket parseSportPacketCountGatt:packet.data];
        if (totalCount == 0) {
            [self closeReadTimer];
            
            BLOCK_EXEC(self.serviceBlock, nil, nil, makeError(GattErrors_EmptyData, LS(@"bluetooth.empty.data")));
            
        } else {
            GattPacket *gattPacket = [GattPacket createSportPacketGatt:0];
            [self sendPacket:gattPacket];
        }
        
    } else if (packet.type == (0x04|0x80)) {
        [self resetReadTimer];
        
        // 保存原始数据
        [sourceData appendData:packet.data];
        
        NSData *paserData = [GattPacket parseSportPacketGatt:packet.data];
        NSInteger index = [GattPacket parseSportIndex:packet.data];
        
        if (paserData && index == readCount + 1) {
            [sportData appendData:paserData];
            
            readCount++;
            if (readCount == totalCount) {
                [self closeReadTimer];
                
                NSDictionary *dataDict = [GattPacket transSportPacketGatt:sportData];
                if (dataDict && self.serviceBlock) {
                    BLOCK_EXEC(self.serviceBlock, dataDict, sourceData, nil);
                } else {
                    BLOCK_EXEC(self.serviceBlock, nil, sourceData, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
                }
                
            } else{
                BLOCK_EXEC(self.progressBlock, totalCount, readCount);
            }
        }
    }
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    [self closeReadTimer];
    
    BLOCK_EXEC(self.serviceBlock, nil, sourceData, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
    GBLog(@"%@ error:%@", self.class, error);
}

#pragma mark - private mothed

- (void)resetReadTimer {
    
    GBLog(@"resetReadTimer");
    if (self.readTimer) {
        [self.readTimer invalidate];
    }
    
    self.readTimer = [NSTimer scheduledTimerWithTimeInterval:kReadTimeInterval target:self selector:@selector(timerDidFire) userInfo:nil repeats:NO];
}

- (void)closeReadTimer {
    
    GBLog(@"closeReadTimer");
    if (self.readTimer) {
        [self.readTimer invalidate];
    }
}

- (void)timerDidFire {
    
    BLOCK_EXEC(self.serviceBlock, nil, sourceData, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
}

- (void)reset {
    
    totalCount = 0;
    readCount = 0;
    sportData = [[NSMutableData alloc] init];
    sourceData = [[NSMutableData alloc] init];
}

@end

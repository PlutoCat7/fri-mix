//
//  RunProfile.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunProfile.h"

@interface RunProfile() <PacketProfileDelegate>
{
    
    NSInteger totalCount;
    NSInteger readCount;
    
    NSMutableData *runData;
    NSMutableData *sourceData;
}

@property (nonatomic, copy) ReadProgressBlock progressBlock;
@property (nonatomic, copy) ReadMultiServiceBlock serviceBlock;

@property (nonatomic, strong) NSTimer *readTimer;

@end

@implementation RunProfile

#pragma mark - OverWrite

- (void)stopTask {
    
    [super stopTask];
    [self closeReadTimer];
}

#pragma mark - Public

- (void)readRunDataWithMonth:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock {
    
    [self reset];
    self.progressBlock = progressBlock;
    self.serviceBlock = serviceBlock;
    
    GattPacket *countGattPacket = [GattPacket createRunPacketCountGatt:month day:day];
    [self sendPacket:countGattPacket];
    
    [self resetReadTimer];
}

#pragma mark - PacketProfileDelegate

- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive) {
        return;
    }
    if (packet.type == GATT_RUN_PACKET_COUNT_BACK) {
        [self resetReadTimer];
        
        totalCount = [GattPacket parseRunPacketCountGatt:packet.data];
        if (totalCount == 0) {
            [self closeReadTimer];
            
            BLOCK_EXEC(self.serviceBlock, nil, nil, makeError(GattErrors_EmptyData, LS(@"bluetooth.empty.data")));
            
        } else {
            GattPacket *gattPacket = [GattPacket createRunPacketGatt:0];
            [self sendPacket:gattPacket];
        }
        
    } else if (packet.type == GATT_RUN_PACKET_BACK) {
        [self resetReadTimer];
        
        // 保存原始数据
        [sourceData appendData:packet.data];
        
        NSData *paserData = [GattPacket parseRunPacketGatt:packet.data];
        NSInteger index = [GattPacket parseRunIndex:packet.data];
        
        if (paserData && index == readCount + 1) {
            [runData appendData:paserData];
            
            readCount++;
            if (readCount == totalCount) {
                [self closeReadTimer];
                
                NSDictionary *dataDict = [GattPacket transRunPacketGatt:runData];
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
    runData = [[NSMutableData alloc] init];
    sourceData = [[NSMutableData alloc] init];
}

@end

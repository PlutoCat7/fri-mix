//
//  BatteryVersionProfile.m
//  GB_Football
//
//  Created by weilai on 16/6/14.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "BatteryVersionProfile.h"

@interface BatteryVersionProfile()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation BatteryVersionProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (instancetype)init {
    
    self = [super init];
    _resultArray = [NSMutableArray arrayWithCapacity:3];
    
    return self;
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)readBatteryVersion:(ReadServiceBlock)serviceBlock {
    
    [self reset];
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *batteryPacket = [GattPacket createBatteryPacketGatt];
    [self sendPacket:batteryPacket];
    
    //超时设置
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    @weakify(self)
    [self performBlock:^{
        @strongify(self)
        BLOCK_EXEC(self.serviceBlock, nil, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
    } delay:kReadTimeInterval];
}

#pragma mark - PeripheralCallBack

- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive) {
        return;
    }
    if (packet.type == (0x0d|0x80) && [self.resultArray count] == 0) {
        NSArray *list = [GattPacket parseBatteryGatt:packet.data];
        if (list.count == 2) {
            [self.resultArray addObject:list.firstObject];
        }else {
            [self.resultArray addObject:[NSNumber numberWithInteger:0]];
        }
        
        GattPacket *gattPacket = [GattPacket createFirewareVerPacketGatt];
        [self sendPacket:gattPacket];
        
    } else if (packet.type == (0x0f|0x80) && [self.resultArray count] == 1) {
        NSString *fireware = [GattPacket parseFirewareGatt:packet.data];
        [self.resultArray addObject:fireware];
        
        BLOCK_EXEC(self.serviceBlock, self.resultArray, nil);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    BLOCK_EXEC(self.serviceBlock, nil, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
    GBLog(@"%@ error:%@", self.class, error);
}

#pragma mark - Private

- (void)reset {
    
    [self.resultArray removeAllObjects];
}

@end


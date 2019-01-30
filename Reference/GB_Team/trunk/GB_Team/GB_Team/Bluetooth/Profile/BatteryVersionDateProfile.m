//
//  BatteryVersionDateProfile.m
//  GB_Football
//
//  Created by weilai on 16/6/14.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "BatteryVersionDateProfile.h"

@interface BatteryVersionDateProfile()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation BatteryVersionDateProfile

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

- (void)readBatteryVersionDate:(ReadServiceBlock)serviceBlock {
    
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
        NSInteger battery = [GattPacket parseBatteryGatt:packet.data];
        [self.resultArray addObject:[NSNumber numberWithInteger:battery]];
        
        GattPacket *gattPacket = [GattPacket createFirewareVerPacketGatt];
        [self sendPacket:gattPacket];
        
    } else if (packet.type == (0x0f|0x80) && [self.resultArray count] == 1) {
        NSString *fireware = [GattPacket parseFirewareGatt:packet.data];
        [self.resultArray addObject:fireware];
        
        GattPacket *gattPacket = [GattPacket createDatePacketGatt];
        [self sendPacket:gattPacket];
        
    } else if (packet.type == (0x0b|0x80)) {
        NSString *dateStr = [GattPacket parserDateGatt:packet.data];
        [self.resultArray addObject:dateStr];
        
        BLOCK_EXEC(self.serviceBlock, self.resultArray, nil);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    BLOCK_EXEC(self.serviceBlock, nil, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
    GBLog(@"%@ error:%@", self.class, error);
}

#pragma mark - Private

- (void)reset {
    
    [self.resultArray removeAllObjects];
}

@end


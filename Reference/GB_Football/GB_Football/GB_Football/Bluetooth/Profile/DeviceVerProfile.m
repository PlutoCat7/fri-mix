//
//  DeviceVerProfile.m
//  GB_Football
//
//  Created by 王时温 on 2017/3/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "DeviceVerProfile.h"

@interface DeviceVerProfile ()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation DeviceVerProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark Public Methods

- (void)readDeviceVersion:(ReadServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *packet = [GattPacket createDeviceVerPacketGatt];
    [self sendPacket:packet];
    
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
    
    if (packet.type == GATT_DEVICE_VER_PACKET_BACK) {
        
        NSString *version = [GattPacket parseDeviceVerGatt:packet.data];
        BLOCK_EXEC(self.serviceBlock, version, nil);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
    }
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (error) {
        BLOCK_EXEC(self.serviceBlock, nil, makeError(error.code, LS(@"bluetooth.read.fail")));
    } else {
        BLOCK_EXEC(self.serviceBlock, nil, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
    }
    
    GBLog(@"%@ error:%@", self.class, error);
}

@end

//
//  DeviceMacProfile.m
//  GB_Football
//
//  Created by gxd on 17/6/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "DeviceMacProfile.h"

@interface DeviceMacProfile ()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation DeviceMacProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark Public Methods

- (void)readDeviceMac:(ReadServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *packet = [GattPacket createDeviceMacPacketGatt];
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
    
    if (packet.type == GATT_DEVICE_MAC_PACKET_BACK) {
        
        NSString *mac = [[GattPacket parseDeviceMacGatt:packet.data] lowercaseString];
        BLOCK_EXEC(self.serviceBlock, mac, nil);
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

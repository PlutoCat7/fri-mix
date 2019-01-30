//
//  CheckGPSProfile.m
//  GB_Football
//
//  Created by 王时温 on 2016/11/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "CheckGPSProfile.h"

@interface CheckGPSProfile ()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation CheckGPSProfile

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)checkGPSWithServiceBlock:(ReadServiceBlock)serviceBlock {
    
    GBLog(@"检查GPS状态");
    self.serviceBlock = serviceBlock;
    
    GattPacket *gattPacket = [GattPacket createCheckGPSPacketGatt];
    [self sendPacket:gattPacket];
    
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
    if (packet.type == (0x30|0x80)) {
        NSInteger status = [GattPacket parseCheckGPSGatt:packet.data];
        
        BLOCK_EXEC(self.serviceBlock, @(status), nil);
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

@end

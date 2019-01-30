//
//  RunTimeProfile.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunTimeProfile.h"

@interface RunTimeProfile()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation RunTimeProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark Public Methods

- (void)readRunTime:(ReadServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *packet = [GattPacket createRunTimePacketGatt];
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
    
    if (packet.type == (GATT_RUN_TIME_PACKET_BACK)) {
        
        NSDictionary *dic = [GattPacket parseRunTime:packet.data];
        BLOCK_EXEC(self.serviceBlock, dic, nil);
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


@end

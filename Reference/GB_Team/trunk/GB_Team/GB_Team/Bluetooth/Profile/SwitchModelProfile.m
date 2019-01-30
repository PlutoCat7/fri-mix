//
//  SwitchModelProfile.m
//  GB_Football
//
//  Created by 王时温 on 2016/11/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SwitchModelProfile.h"

@interface SwitchModelProfile ()

@property (nonatomic, copy) WriteServiceBlock serviceBlock;

@end

@implementation SwitchModelProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)switchModelWithIndx:(NSInteger)index serviceBlock:(WriteServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *gattPacket = [GattPacket createSwitchModelPacketGatt:index];
    [self sendPacket:gattPacket];
    
    //超时设置
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    @weakify(self)
    [self performBlock:^{
        @strongify(self)
        BLOCK_EXEC(self.serviceBlock, makeError(GattErrors_PaserFail, LS(@"bluetooth.write.fail")));
    } delay:kReadTimeInterval];
}

#pragma mark - PeripheralCallBack

- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive) {
        return;
    }
    if (packet.type == (0x07|0x80)) {
        NSInteger success = [GattPacket parseSwitchModelGatt:packet.data];
        NSError *error = nil;
        if (success != 0) {
            error = makeError(GattErrors_PaserFail, LS(@"bluetooth.write.fail"));
        }
        BLOCK_EXEC(self.serviceBlock, error);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    
    BLOCK_EXEC(self.serviceBlock, makeError(GattErrors_PaserFail, LS(@"bluetooth.write.fail")));
    GBLog(@"%@ error:%@", self.class, error);
}

@end

//
//  CloseProfile.m
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "CloseProfile.h"

@interface CloseProfile ()

@property (nonatomic, copy) WriteServiceBlock serviceBlock;

@end

@implementation CloseProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)closeWithserviceBlock:(WriteServiceBlock)serviceBlock
{
    self.serviceBlock = serviceBlock;
    GattPacket *gattPacket = [GattPacket createClosePacketGatt];
    [self sendPacket:gattPacket];
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
    if (packet.type == (0x17|0x80)) {
        BOOL success = [GattPacket parseClosePacketGatt:packet.data];
        NSError *error = nil;
        if (success == NO) {
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    BLOCK_EXEC(self.serviceBlock, makeError(GattErrors_PaserFail, LS(@"bluetooth.write.fail")));
    GBLog(@"%@ error:%@", self.class, error);
}

@end

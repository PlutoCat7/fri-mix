//
//  ResetProfile.m
//  GB_Football
//
//  Created by Pizza on 2017/1/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "ResetProfile.h"

@interface ResetProfile ()

@property (nonatomic, copy) WriteServiceBlock serviceBlock;

@end

@implementation ResetProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)resetWithserviceBlock:(WriteServiceBlock)serviceBlock
{
    self.serviceBlock = serviceBlock;
    GattPacket *gattPacket = [GattPacket createResetPacketGatt];
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
    if (packet.type == (0x32|0x80)) {
        BOOL success = [GattPacket parseResetPacketGatt:packet.data];
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
    
    BLOCK_EXEC(self.serviceBlock, makeError(GattErrors_PaserFail, LS(@"bluetooth.write.fail")));
    GBLog(@"%@ error:%@", self.class, error);
}


@end

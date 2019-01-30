//
//  AdjustDateProfile.m
//  GB_Football
//
//  Created by weilai on 16/6/14.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "AdjustDateProfile.h"

@interface AdjustDateProfile()  <PacketProfileDelegate>

@property (nonatomic, copy) WriteServiceBlock serviceBlock;

@end

@implementation AdjustDateProfile

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)adjustDate:(NSDateComponents *)date serviceBlock:(WriteServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *gattPacket = [GattPacket createAjustPacketGatt:date];
    [self sendPacket:gattPacket];

    //超时设置
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    @weakify(self)
    [self performBlock:^{
        @strongify(self)
        BLOCK_EXEC(self.serviceBlock, makeError(GattErrors_PaserFail, LS(@"bluetooth.write.fail")));
        self.serviceBlock = nil;
    } delay:kWriteTimeInterval];
}

#pragma mark - PeripheralCallBack
- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive) {
        return;
    }
    if (packet.type == (0x0c|0x80)) {
        BLOCK_EXEC(self.serviceBlock, nil);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    BLOCK_EXEC(self.serviceBlock, makeError(GattErrors_PaserFail, LS(@"bluetooth.write.fail")));
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    GBLog(@"%@ error:%@", self.class, error);
}

@end

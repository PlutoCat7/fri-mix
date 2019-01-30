//
//  VersionProfile.m
//  GB_Team
//
//  Created by 王时温 on 2016/11/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "VersionProfile.h"

@interface VersionProfile()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation VersionProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark Public Methods

- (void)readVersion:(ReadServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *gattPacket = [GattPacket createFirewareVerPacketGatt];
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
    
    if (packet.type == (0x0f|0x80)) {
        NSString *fireware = [GattPacket parseFirewareGatt:packet.data];
        BLOCK_EXEC(self.serviceBlock, fireware, nil);
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

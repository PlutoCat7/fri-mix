//
//  CheckModelProfile.m
//  GB_Football
//
//  Created by 王时温 on 2016/11/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  查询手环模式

#import "CheckModelProfile.h"

@interface CheckModelProfile ()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation CheckModelProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)checkModelWithServiceBlock:(ReadServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *gattPacket = [GattPacket createCheckModelPacketGatt];
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
    if (packet.type == (0x22|0x80)) {
        NSInteger currentModel = [GattPacket parseCheckModelGatt:packet.data];
        
        BLOCK_EXEC(self.serviceBlock, @(currentModel), nil);
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

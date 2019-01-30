//
//  RunCleanProfile.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunCleanProfile.h"

@interface RunCleanProfile()

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation RunCleanProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark Public Methods

- (void)cleanData:(ReadServiceBlock)serviceBlock {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *packet = [GattPacket createFlashCleanGatt:FlashCleanType_Run];
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
    
    if (packet.type == (GATT_RUN_CLEAN_PACKET_BACK)) {
        
        FlashCleanType type = [GattPacket parseCleanFalshGatt:packet.data];
        if (type == FlashCleanType_Run) {
            BLOCK_EXEC(self.serviceBlock, @(YES), nil);
        }else {
           
            BLOCK_EXEC(self.serviceBlock, @(NO), nil);
        }
        
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

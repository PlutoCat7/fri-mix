//
//  PacketProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/19.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PacketProfile.h"
#import "GBBleConstants.h"
#import "GBBleEnums.h"

@implementation PacketProfile

#pragma public 

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)sendPacket:(GattPacket *)gattPacket {
    //Send Packet
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendPacket:)]) {
        [self.delegate sendPacket:gattPacket];
    }
    
    //超时设置
    [self resetResponseTimeOver];
}

- (void)executeProfile:(ResultServiceBlock)serviceBlock {
    self.serviceBlock = serviceBlock;
    
    // 执行前初始化一些数据
    [self doInitBeforeExecute];
    
    GattPacket *gattPacket = [self createGattPacket];
    [self sendPacket:gattPacket];
}

- (void)cancelProfile {
    [self closeResponseTimeOver];
    
    BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"cancel profile" code:GattErrors_ExitSync userInfo:nil]);
}

#pragma mark - PeripheralCallBack
- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    GBBleLog(@"%@ packet:%@", self.class, packet);
    
    // 如果是无效指令
    if (packet.head == Invalid_Commond) {
        [self closeResponseTimeOver];
        BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"Commond Invalid" code:GattErrors_NoSupport userInfo:nil]);
        
    } else if ([self isCurrentProfileResponse:packet]) {
        [self closeResponseTimeOver];
        [self doGattPacketProfile:profile packet:packet];
        
    }
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    GBBleLog(@"%@ error:%@", self.class, error);
    
    [self closeResponseTimeOver];
    [self doGattPacketProfile:profile error:error];
    
    BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, error);
}

- (void)gattPacketProfileWriteNotify:(PacketProfile *)profile {
    GBBleLog(@"%@ gattPacketProfileWriteNotify", self.class);
    
    [self closeResponseTimeOver];
    [self doGattPacketProfileWriteNotify:profile];
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    NSAssert(NO, @"createGattPacket must be overrided");
    return nil;
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    NSAssert(NO, @"isCurrentProfileResponse must be overrided");
    return NO;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
}

- (void)doGattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
}

- (void)doGattPacketProfileWriteNotify:(PacketProfile*)profile {
}

- (BOOL)isEqualProfile:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }

    return YES;
}

#pragma mark - Private
- (void)resetResponseTimeOver {
    //超时设置
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    __weak typeof(self) weakSelf = self;
    [self performBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BLE_BLOCK_EXEC(strongSelf.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"response over time" code:GattErrors_SyncData userInfo:nil]);
        
    } delay:kResponseTimeInterval];
}

- (void)closeResponseTimeOver {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)performBlock:(void(^)(void))block delay:(NSInteger)delay; {
    
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void(^)(void))block {
    
    if (block) {
        block();
    }
}

@end

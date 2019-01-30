//
//  CheckModelProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/27.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "CheckModelProfile.h"

@implementation CheckModelProfile

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createCheckModelPacketGatt];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_CHECK_MODEL_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    NSInteger currentModel = [GattPacket parseCheckModelGatt:packet.data];
    
    BLE_BLOCK_EXEC(self.serviceBlock, @(currentModel), packet.data, nil);
}

@end

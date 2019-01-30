//
//  FirewareVerProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/28.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "FirewareVerProfile.h"

@implementation FirewareVerProfile

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createFirewareVerPacketGatt];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_FIREWARE_VER_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    NSString *version = [GattPacket parseFirewareVerGatt:packet.data];
    
    BLE_BLOCK_EXEC(self.serviceBlock, version, packet.data, nil);
}

@end

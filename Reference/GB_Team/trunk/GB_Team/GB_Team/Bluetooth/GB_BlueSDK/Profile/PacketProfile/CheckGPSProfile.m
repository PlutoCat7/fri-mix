//
//  CheckGPSProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/27.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "CheckGPSProfile.h"

@implementation CheckGPSProfile

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createCheckGPSPacketGatt];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_CHECK_GPS_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    NSInteger status = [GattPacket parseCheckGPSGatt:packet.data];
    
    BLE_BLOCK_EXEC(self.serviceBlock, @(status), packet.data, nil);
}

@end

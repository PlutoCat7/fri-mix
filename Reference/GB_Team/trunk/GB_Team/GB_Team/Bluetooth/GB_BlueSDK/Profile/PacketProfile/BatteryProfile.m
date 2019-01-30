//
//  BatteryProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/19.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "BatteryProfile.h"

@implementation BatteryProfile


#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createBatteryPacketGatt];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_BATTERY_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    NSInteger battery = [GattPacket parseBatteryGatt:packet.data];
    
    BLE_BLOCK_EXEC(self.serviceBlock, @(battery), packet.data, nil);
}

@end

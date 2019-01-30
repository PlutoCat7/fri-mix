//
//  VariableInfoProfile.m
//  GB_BlueSDK
//
//  Created by 王时温 on 2017/3/27.
//  Copyright © 2017年 GoBrother. All rights reserved.
//

#import "VariableInfoProfile.h"

@implementation VariableInfoProfile

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    
    return [GattPacket createVariableInfoPacketGatt];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_READ_VARIABLE_INFO_PACK_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    NSArray *result = [GattPacket parseVariableInfoPacketGatt:packet.data];
    if (!result) {
        BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"Switch model fail." code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    BLE_BLOCK_EXEC(self.serviceBlock, result, packet.data, nil);
}

@end

//
//  ResetProfile.m
//  GB_Football
//
//  Created by Pizza on 2017/1/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "ResetProfile.h"

@interface ResetProfile ()

@end

@implementation ResetProfile

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    
    return [GattPacket createResetPacketGatt];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_RESET_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    BOOL success = [GattPacket parseResetPacketGatt:packet.data];
    if (!success) {
        BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"Switch model fail." code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    BLE_BLOCK_EXEC(self.serviceBlock, nil, packet.data, nil);
}


@end

//
//  AdjustDateProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/27.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "AdjustDateProfile.h"

@interface AdjustDateProfile()

@property (nonatomic, copy) NSDate *date;

@end

@implementation AdjustDateProfile

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        _date = date;
    }
    return self;
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createAjustPacketGatt:self.date];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_ADJUST_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    NSInteger code = [GattPacket parseAdjustDataGatt:packet.data];
    if (code != BleOptState_Success) {
        BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"Adjust date fail." code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    BLE_BLOCK_EXEC(self.serviceBlock, nil, packet.data, nil);
}

@end

//
//  SwitchModelProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/27.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "SwitchModelProfile.h"

@interface SwitchModelProfile()

@property (nonatomic, assign) NSInteger model;

@end

@implementation SwitchModelProfile

- (instancetype)initWithModel:(NSInteger)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createSwitchModelPacketGatt:self.model];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_SWITCH_MODEL_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    NSInteger code = [GattPacket parseAdjustDataGatt:packet.data];
    if (code != BleOptState_Success) {
        BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"Switch model fail." code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    BLE_BLOCK_EXEC(self.serviceBlock, nil, packet.data, nil);
}

- (BOOL)isEqualProfile:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    if (self.model != ((SwitchModelProfile *) object).model) {
        return NO;
    }
    return YES;
}


@end

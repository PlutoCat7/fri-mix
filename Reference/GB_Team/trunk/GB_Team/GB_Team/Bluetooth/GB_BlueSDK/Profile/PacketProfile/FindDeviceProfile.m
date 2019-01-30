//
//  FindDeviceProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/27.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "FindDeviceProfile.h"

@interface FindDeviceProfile()

@property (nonatomic, assign) BleFindState findState;

@end

@implementation FindDeviceProfile

- (instancetype)initWithFindState:(BleFindState)findState {
    if (self = [super init]) {
        _findState = findState;
    }
    return self;
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createSearchPacketGatt:self.findState];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return packet.head == PACKET_HEAD && packet.type == GATT_SEARCH_PACKET_BACK;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    BLE_BLOCK_EXEC(self.serviceBlock, nil, packet.data, nil);
}

- (BOOL)isEqualProfile:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    if (self.findState != ((FindDeviceProfile *) object).findState) {
        return NO;
    }
    return YES;
}


@end

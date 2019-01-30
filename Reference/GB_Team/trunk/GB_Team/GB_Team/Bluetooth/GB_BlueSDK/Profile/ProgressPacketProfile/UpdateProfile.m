//
//  UpdateProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/28.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "UpdateProfile.h"

static const NSInteger LENGTH = 16;

// 发送数据的扩展
@interface PacketProfile(UpdateExtend)

- (void)sendPacket:(GattPacket *)gattPacket;
- (void)resetResponseTimeOver;
- (void)closeResponseTimeOver;

@end

@interface UpdateProfile()

@property (nonatomic, copy) NSURL *filePath;

@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger total;

@end

@implementation UpdateProfile

- (instancetype)initWithFilePath:(NSURL *)filePath {
    if (self = [super init]) {
        _filePath = [filePath copy];
    }
    return self;
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createFirewareCountPacketGatt:(UInt16)self.total data:self.fileData];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return (packet.head == PACKET_HEAD && packet.type == GATT_FIREWARE_COUNT_PACKET_BACK) || packet.head == UPDATE_BACK_HEAD;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    self.fileData = [NSData dataWithContentsOfURL:self.filePath];
    self.total = (int) (self.fileData.length) / LENGTH;
    self.total += (self.fileData.length) % LENGTH > 0 ? 1 : 0;
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    if (packet.head == PACKET_HEAD && packet.type == GATT_FIREWARE_COUNT_PACKET_BACK) {
        [self writeUpdateData];
        
    } else if (packet.head == UPDATE_BACK_HEAD) {
        [self closeResponseTimeOver];
        
        NSData *paserData = [GattPacket parseFirewareUpdateGatt:packet.data];
        if (paserData && paserData.length == 2) {
            Byte *bytes = (Byte *)[paserData bytes];
            if (bytes[0] == 0x00 && bytes[1] == 0x00) {
                BLE_BLOCK_EXEC(self.serviceBlock, nil, paserData, nil);
            } else {
                BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [NSError errorWithDomain:@"update fireware fail." code:GattErrors_PaserFail userInfo:nil]);
            }
            
        } else {
            BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [NSError errorWithDomain:@"update fireware fail." code:GattErrors_PaserFail userInfo:nil]);
        }
    }

}

- (void)doGattPacketProfileWriteNotify:(PacketProfile*)profile {
    
    BLE_BLOCK_EXEC(self.progressBlock, self.total, self.position);
    [self writeUpdateData];
}

- (BOOL)isEqualProfile:(id)object {
    
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    if (![[self.filePath.absoluteString lowercaseString] isEqualToString:[((UpdateProfile *)object).filePath.absoluteString lowercaseString]]) {
        return NO;
    }
    return YES;
}


#pragma mark - Private

// 写入更新数据
- (void)writeUpdateData {
    if (self.position < self.total) {
        NSInteger length = (self.position + 1) * LENGTH > self.fileData.length ? (self.fileData.length - self.position * LENGTH) : LENGTH;
        NSData *itemData = [self.fileData subdataWithRange:NSMakeRange(self.position * LENGTH, length)];
        GattPacket *gattPacket = [GattPacket createFirewarePacketGatt:(self.position + 1) data:itemData];
        [self sendPacket:gattPacket];
        
        self.position = self.position + 1;
    }
}

@end

//
//  AGPSProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/29.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "AGPSProfile.h"

static const NSInteger LENGTH = 15;

// 发送数据的扩展
@interface PacketProfile(AGPSExtend)

- (void)sendPacket:(GattPacket *)gattPacket;
- (void)resetResponseTimeOver;
- (void)closeResponseTimeOver;

@end

@interface AGPSProfile()

@property (nonatomic, copy) NSURL *filePath;

@property (nonatomic, strong) NSArray<NSArray<NSData *> *> *packetDataList;
@property (nonatomic, assign) NSInteger orderIndex;             //当前命令索引
@property (nonatomic, assign) NSInteger orderProgressIndex;     //当前命令索引进度

@property (nonatomic, assign) NSInteger totalPacket;            //包总数
@property (nonatomic, assign) NSInteger progressIndex;          //进度位置

@property (nonatomic, assign) BOOL isStartAGPS;

@end

@implementation AGPSProfile

- (instancetype)initWithFilePath:(NSURL *)filePath {
    if (self = [super init]) {
        _filePath = [filePath copy];
    }
    return self;
}

#pragma mark - Protected 子类必须实现的方式
- (GattPacket *)createGattPacket {
    return [GattPacket createAGPSCountPacketGatt:self.packetDataList.count];
}

- (BOOL)isCurrentProfileResponse:(GattPacket *)packet {
    return (packet.head == PACKET_HEAD && packet.type == GATT_AGPS_COUNT_PACKET_BACK) || packet.head == SEARCHSTAR_HEAD;
}

#pragma mark - Protected 子类选择实现的方式
- (void)doInitBeforeExecute {
    NSData *fileData = [NSData dataWithContentsOfURL:self.filePath];
    [[NSFileManager defaultManager] removeItemAtURL:self.filePath error:nil];
    [self resetWithFileData:fileData];
    
}

- (void)doGattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    if (packet.head == PACKET_HEAD && packet.type == GATT_AGPS_COUNT_PACKET_BACK) {
        self.isStartAGPS = YES;
        [self writeSarchStartData];
        
    } else if (packet.head == SEARCHSTAR_HEAD) {
        [self closeResponseTimeOver];
        
        NSInteger code = [GattPacket parseSearchStartGatt:packet.data];
        if (code == 0) { //命令写入成功， 继续下一条
            if (self.orderIndex == self.packetDataList.count - 1) { //星历传输完成
                self.isStartAGPS = NO;
                self.packetDataList = nil;
                
                [self closeResponseTimeOver];
                BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, nil);
                
            } else {
                self.orderIndex++;
                self.orderProgressIndex = 0;
                [self writeSarchStartData];
            }
        } else {
            self.isStartAGPS = NO;
            BLE_BLOCK_EXEC(self.serviceBlock, nil, nil, [NSError errorWithDomain:@"write agps fail" code:GattErrors_PaserFail userInfo:nil]);
        }
    }
    
}

- (void)doGattPacketProfileWriteNotify:(PacketProfile*)profile {
    if (self.isStartAGPS) {
        BLE_BLOCK_EXEC(self.progressBlock, self.totalPacket, ++self.progressIndex);
        
        if (self.orderProgressIndex + 1 == self.packetDataList[self.orderIndex].count) {//当前命令已发送完成
            return;
        }
        self.orderProgressIndex++;
        [self writeSarchStartData];
    }
    
}

- (BOOL)isEqualProfile:(id)object {
    
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    if (![[self.filePath.absoluteString lowercaseString] isEqualToString:[((AGPSProfile *)object).filePath.absoluteString lowercaseString]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Private

- (void)cancelProfile {
    [self closeResponseTimeOver];
    self.isStartAGPS = NO;
    
    if (self.packetDataList.count) {  //星历开始写入
        //取消星历写入
        GattPacket *countGattPacket = [GattPacket createAGPSCountPacketGatt:0];
        [self sendPacket:countGattPacket];
        
        [self closeResponseTimeOver];
        self.packetDataList = nil;
    }
    
    BLE_BLOCK_EXEC_SetNil(self.serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"cancel profile" code:GattErrors_ExitSync userInfo:nil]);
}

// 写入数据
- (void)writeSarchStartData {
    if (self.packetDataList.count == 0 || self.isStartAGPS == NO) {
        return;
    }
    if (self.orderIndex >= self.packetDataList.count) {
        return;
    }
    if (self.orderProgressIndex >= self.packetDataList[self.orderIndex].count) {
        return;
    }
    GattPacket *countGattPacket = [GattPacket createAGPSPacketGatt:self.packetDataList[self.orderIndex].count
                                                        orderIndex:self.orderIndex
                                                       packetIndex:self.orderProgressIndex
                                                              data:self.packetDataList[self.orderIndex][self.orderProgressIndex]];
    [self sendPacket:countGattPacket];
}

- (void)resetWithFileData:(NSData *)fileData {
    
    self.packetDataList = nil;
    self.orderIndex = 0;
    self.orderProgressIndex = 0;
    self.totalPacket = 0;
    self.progressIndex = 0;
    self.isStartAGPS = NO;
    
    //获取字节的个数
    NSUInteger length = [fileData length];
    NSInteger startIndex = 0;
    NSMutableArray<NSData *> *orderList = [NSMutableArray arrayWithCapacity:1];
    for(int i = 0; i < length; i++) {
        //读取数据
        UInt8 b = 0;
        [fileData getBytes:&b range:NSMakeRange(i, sizeof(b))];
        if (b == 0xb5) {
            if (i+1<length) {
                [fileData getBytes:&b range:NSMakeRange(i+1, sizeof(b))];
                if (b == 0x62) {
                    if (i-startIndex > 0) {
                        NSData *pactData = [fileData subdataWithRange:NSMakeRange(startIndex, i-startIndex)];
                        startIndex = i;
                        [orderList addObject:pactData];
                    }
                }
            }
            
        }
        if (i == length-1 && startIndex>0) { //最后一个包
            NSData *pactData = [fileData subdataWithRange:NSMakeRange(startIndex, length-startIndex)];
            startIndex = i;
            [orderList addObject:pactData];
        }
        
    }
    //    if (orderList.count > 0) { //第一条命令去除
    //        [orderList removeObjectAtIndex:0];
    //    }

    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    for (NSData *data in orderList) {
        NSMutableArray *packetList = [NSMutableArray arrayWithCapacity:1];
        NSInteger total = (int) (data.length) / LENGTH;
        total += (data.length) % LENGTH > 0 ? 1 : 0;
        for (NSInteger i=0; i<total; i++) {
            NSInteger length = (i + 1) * LENGTH > data.length ? (data.length - i * LENGTH) : LENGTH;
            [packetList addObject:[data subdataWithRange:NSMakeRange(i * LENGTH, length)]];
        }
        self.totalPacket += total;
        [list addObject:[packetList copy]];
    }
    self.packetDataList = [list copy];
}


@end

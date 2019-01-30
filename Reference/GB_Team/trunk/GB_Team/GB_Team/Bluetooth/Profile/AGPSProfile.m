//
//  AGPSProfile.m
//  GB_Football
//
//  Created by wsw on 2016/10/28.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "AGPSProfile.h"

static const NSInteger LENGTH = 15;

@interface AGPSProfile () <PacketProfileDelegate>

@property (nonatomic, strong) NSArray<NSArray<NSData *> *> *packetDataList;
@property (nonatomic, assign) NSInteger orderIndex;             //当前命令索引
@property (nonatomic, assign) NSInteger currentPacketIndex;      //当前包索引

@property (nonatomic, assign) NSInteger totalPacket;            //包总数
@property (nonatomic, assign) NSInteger progressIndex;          //进度位置

@property (nonatomic, copy) WriteServiceBlock serviceBlock;
@property (nonatomic, copy) ReadProgressBlock progressBlock;

@property (nonatomic, strong) NSTimer *writeTimer;
@property (nonatomic, assign) BOOL isStartAGPS;
@property (nonatomic, assign) BOOL isCancel;

@end

@implementation AGPSProfile

#pragma mark - OverWrite

- (void)stopTask {
    
    [super stopTask];
    [self closeWriteTimer];
    [self cancelAGPS];
}

#pragma mark - Public

- (void)doAGPSProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock {
    
    self.serviceBlock = serviceBlock;
    self.progressBlock = progressBlock;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *fileData = [NSData dataWithContentsOfURL:filePath];
        [self resetWithFileData:fileData];
        if (!fileData) {
            NSLog(@"");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GattPacket *countGattPacket = [GattPacket createAGPSCountPacketGatt:self.packetDataList.count];
            [self sendPacket:countGattPacket];
            [self resetWriteTimer];
        });
    });
}

- (void)cancelAGPS {
    
    if (self.packetDataList.count) {  //星历开始写入
        //取消星历写入
        GattPacket *countGattPacket = [GattPacket createAGPSCountPacketGatt:0];
        [self sendPacket:countGattPacket];
        
        [self closeWriteTimer];
        
        self.isCancel = YES;
        self.packetDataList = nil;
        BLOCK_EXEC(self.serviceBlock, nil);
        self.serviceBlock = nil;
    }
}

#pragma mark - PacketProfileDelegate
- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive || self.isCancel) {
        return;
    }
    
    if (packet.type == (0x24|0x80)) {
        self.isStartAGPS = YES;
        [self writeSarchStartData];
    }else if (packet.type == 0xa6) {
        NSInteger code = [GattPacket parseSearchStartGatt:packet.data];
        if (code == 0) { //命令写入成功， 继续下一条
            [self closeWriteTimer];
            if (self.orderIndex == self.packetDataList.count - 1) { //星历传输完成
                self.isStartAGPS = NO;
                self.packetDataList = nil;
                BLOCK_EXEC(self.serviceBlock, nil);
            }else {
                self.orderIndex++;
                self.currentPacketIndex = 0;
                [self writeSarchStartData];
            }
        }else {
            self.isStartAGPS = NO;
            BLOCK_EXEC(self.serviceBlock, [NSError errorWithDomain:LS(@"写入失败") code:GattErrors_PaserFail userInfo:nil]);
        }
    }
    //GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error{
    
    if (!self.isActive || self.isCancel) {
        return;
    }
    self.isStartAGPS = NO;
    BLOCK_EXEC(self.serviceBlock, [NSError errorWithDomain:LS(@"写入失败") code:GattErrors_PaserFail userInfo:nil]);
    GBLog(@"%@ error:%@", self.class, error);
}

- (void)gattPacketProfileWriteNotify:(PacketProfile *)profile {

    if (!self.isActive || self.isCancel) {
        return;
    }
    if (self.isStartAGPS) {
        if (self.progressBlock) {
            self.progressIndex++;
            CGFloat progress = (self.progressIndex*1.0)/self.totalPacket;
            self.progressBlock(progress);
        }
        
        if (self.currentPacketIndex+1 == self.packetDataList[self.orderIndex].count) {//当前命令已发送完成
            return;
        }
        self.currentPacketIndex++;
        [self writeSarchStartData];
    }
}

#pragma mark - Timer

- (void)resetWriteTimer {
    
    [self closeWriteTimer];
    
    self.writeTimer = [NSTimer scheduledTimerWithTimeInterval:kWriteTimeInterval target:self selector:@selector(timerDidFire) userInfo:nil repeats:NO];
   
}

- (void)closeWriteTimer {
    
    [self.writeTimer invalidate];
}

- (void)timerDidFire {
    
    BLOCK_EXEC(self.serviceBlock, [NSError errorWithDomain:LS(@"写入失败") code:GattErrors_PaserFail userInfo:nil]);
}

#pragma mark - Private

- (void)writeSarchStartData {
    
    [self resetWriteTimer];
    
    if (self.packetDataList.count == 0) {
        return;
    }
    if (self.orderIndex >= self.packetDataList.count) {
        return;
    }
    if (self.currentPacketIndex >= self.packetDataList[self.orderIndex].count) {
        return;
    }
    GattPacket *countGattPacket = [GattPacket createAGPSPacketGatt:self.packetDataList[self.orderIndex].count
                                                               orderIndex:self.orderIndex
                                                              packetIndex:self.currentPacketIndex
                                                                     data:self.packetDataList[self.orderIndex][self.currentPacketIndex]];
    [self sendPacket:countGattPacket];
}

- (void)resetWithFileData:(NSData *)fileData {
    
    //重置
    [self closeWriteTimer];

    self.packetDataList = nil;
    self.orderIndex = 0;
    self.currentPacketIndex = 0;
    self.isStartAGPS = NO;
    self.isCancel = NO;
    
    //获取字节的个数
    NSUInteger length = [fileData length];
    NSInteger startIndex = 0;
    NSMutableArray<NSData *> *orderList = [NSMutableArray arrayWithCapacity:1];
    for(int i = 0; i < length; i++)
    {
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
    
    self.orderIndex = 0;
    self.currentPacketIndex = 0;
    self.totalPacket = 0;
    self.progressIndex = 0;
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    for (NSData *data in orderList) {
        GBLog(@"-------->data:%@", data);
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

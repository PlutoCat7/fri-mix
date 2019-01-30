//
//  UpdateProfile.m
//  GB_Football
//
//  Created by weilai on 16/4/19.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "UpdateProfile.h"

static const NSInteger LENGTH = 16;

@interface UpdateProfile()  <PacketProfileDelegate>

@property (nonatomic, strong) NSTimer *writeTimer;
@property (nonatomic, copy) WriteServiceBlock serviceBlock;
@property (nonatomic, copy) ReadProgressBlock progressBlock;

@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) BOOL isStartUpdate;

@end

@implementation UpdateProfile

- (void)stopTask {
    
    [super stopTask];
    [self closeWriteTimer];
}

#pragma mark - Public

- (void)sendUpdateProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock {
    
    [self reset];
    self.serviceBlock = serviceBlock;
    self.progressBlock = progressBlock;
    
    self.fileData = [NSData dataWithContentsOfURL:filePath];
    self.total = (int) (self.fileData.length) / LENGTH;
    self.total += (self.fileData.length) % LENGTH > 0 ? 1 : 0;
    
    GattPacket *countGattPacket = [GattPacket createFirewareCountPacketGatt:(UInt16)self.fileData.length data:self.fileData];
    [self sendPacket:countGattPacket];
    
    [self resetWriteTimer:NO];
}

#pragma mark - PeripheralCallBack

- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive) {
        return;
    }

    if (packet.type == (0x14|0x80)) {
        self.isStartUpdate = YES;
        [self writeUpdateData];
    } else if (packet.type == 0xa8) {
        [self closeWriteTimer];
        
        NSData *paserData = [GattPacket parseFirewareUpdateGatt:packet.data];
        if (paserData && paserData.length == 2) {
            Byte *bytes = (Byte *)[paserData bytes];
            if (bytes[0] == 0x00 && bytes[1] == 0x00) {
                BLOCK_EXEC(self.serviceBlock, nil);
            } else {
                BLOCK_EXEC(self.serviceBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
            }
            
        } else {
            BLOCK_EXEC(self.serviceBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
        }
    }
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    BLOCK_EXEC(self.serviceBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
    GBLog(@"%@ error:%@", self.class, error);
}

- (void)gattPacketProfileWriteNotify:(PacketProfile *)profile {
    
    if (!self.isActive) {
        return;
    }
    if (self.isStartUpdate) {
        
        BLOCK_EXEC(self.progressBlock, self.position*1.0/self.total);
        
        [self writeUpdateData];
    }
}

#pragma mark - Private

- (void)writeUpdateData {
    
    [self resetWriteTimer:YES];
    
    if (self.position < self.total) {
        NSInteger length = (self.position + 1) * LENGTH > self.fileData.length ? (self.fileData.length - self.position * LENGTH) : LENGTH;
        NSData *itemData = [self.fileData subdataWithRange:NSMakeRange(self.position * LENGTH, length)];
        GattPacket *gattPacket = [GattPacket createFirewarePacketGatt:(self.position + 1) data:itemData];
        [self sendPacket:gattPacket];
        
        self.position = self.position + 1;
    }
}

- (void)resetWriteTimer:(BOOL)isWrite {
    
    [self closeWriteTimer];
    
    if (isWrite) {
        self.writeTimer = [NSTimer scheduledTimerWithTimeInterval:kWriteTimeInterval target:self selector:@selector(timerDidFire) userInfo:nil repeats:NO];
    } else {
        self.writeTimer = [NSTimer scheduledTimerWithTimeInterval:kReadTimeInterval target:self selector:@selector(timerDidFire) userInfo:nil repeats:NO];
    }
    
}

- (void)closeWriteTimer {
    
    if (self.writeTimer) {
        [self.writeTimer invalidate];
    }
}

- (void)timerDidFire {
    
    BLOCK_EXEC(self.serviceBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
}

- (void)reset {
    
    self.isStartUpdate = NO;
    self.total = 0;
    self.position = 0;
    self.fileData = nil;
    self.progressBlock = nil;
    self.serviceBlock = nil;
    [self closeWriteTimer];
}

@end

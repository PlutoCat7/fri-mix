//
//  SearchProfile.m
//  GB_Team
//
//  Created by wsw on 2016/9/30.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SearchProfile.h"


@interface SearchProfile () <
PacketProfileDelegate>

@property (nonatomic, copy) ReadServiceBlock serviceBlock;

@end

@implementation SearchProfile

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTask {
    
    [super stopTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Public

- (void)searchWrist:(ReadServiceBlock)serviceBlock isStart:(BOOL)isStart {
    
    self.serviceBlock = serviceBlock;
    
    GattPacket *gattPacket = [GattPacket createSearchPacketGatt:isStart];
    [self sendPacket:gattPacket];
    
    //超时设置
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    @weakify(self)
    [self performBlock:^{
        @strongify(self)
        BLOCK_EXEC(self.serviceBlock, nil, [NSError errorWithDomain:@"寻找失败" code:GattErrors_PaserFail userInfo:nil]);
    } delay:kReadTimeInterval];
}

#pragma mark - PacketProfileDelegate
- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (!self.isActive) {
        return;
    }
    
    if (packet.type == (0x1f|0x80)) {

        BLOCK_EXEC(self.serviceBlock, @(YES), nil);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    GBLog(@"%@ packet:%@", self.class, packet);
}

- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error {
    
    if (!self.isActive) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    BLOCK_EXEC(self.serviceBlock, nil, [NSError errorWithDomain:@"寻找失败" code:GattErrors_PaserFail userInfo:nil]);
    GBLog(@"%@ error:%@", self.class, error);
}

@end

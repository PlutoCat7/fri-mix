//
//  PacketProfile.m
//  GB_Football
//
//  Created by weilai on 16/3/11.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PacketProfile.h"

@interface PacketProfile()  

@end

@implementation PacketProfile

#pragma mark Public Methods

- (void)sendPacket:(GattPacket *)gattPacket {
    
    //Send Packet
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendPacket:)]) {
        [self.delegate sendPacket:gattPacket];
    }
}

- (void)startTask {
    
    self.isActive = YES;
}

- (void)stopTask {
    
    self.isActive = NO;
}

@end

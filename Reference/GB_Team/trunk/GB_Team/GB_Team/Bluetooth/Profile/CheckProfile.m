//
//  CheckProfile.m
//  GB_Football
//
//  Created by 王时温 on 2016/11/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "CheckProfile.h"

@implementation CheckProfile

#pragma mark - PacketProfileDelegate

- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet {
    
    if (packet && packet.type == 0x13) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeviceCheck object:nil];
        GBLog(@"%@ packet:%@", self.class, packet);
    }
}

@end

//
//  PacketProfile.h
//  GB_Football
//
//  Created by weilai on 16/3/11.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GattPacket.h"
#import "BleGlobal.h"

@class PacketProfile;
@protocol PacketProfileDelegate <NSObject>

- (void)sendPacket:(GattPacket *)gattPacket;

@end

@protocol PeripheralCallBack <NSObject>

@optional
- (void)gattPacketProfileWriteNotify:(PacketProfile*)profile;
- (void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet;
- (void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error;

@end

@interface PacketProfile : NSObject<
PeripheralCallBack>

@property (nonatomic, weak) id<PacketProfileDelegate> delegate;
@property (nonatomic, assign) BOOL isActive;

- (void)startTask;
- (void)stopTask;
- (void)sendPacket:(GattPacket *)gattPacket;

@end


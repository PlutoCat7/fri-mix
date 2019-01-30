//
//  PacketProfile.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/19.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GBBleConstants.h"
#import "GBBleEnums.h"
#import "GattPacket.h"

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

@interface PacketProfile : NSObject <PeripheralCallBack>

@property (nonatomic, copy) ResultServiceBlock serviceBlock;
@property (nonatomic, weak) id<PacketProfileDelegate> delegate;
    

// 执行profile
- (void)executeProfile:(ResultServiceBlock)serviceBlock;
// 取消profile
- (void)cancelProfile;

// 判断两个profile是否相等
- (BOOL)isEqualProfile:(id)object;

@end

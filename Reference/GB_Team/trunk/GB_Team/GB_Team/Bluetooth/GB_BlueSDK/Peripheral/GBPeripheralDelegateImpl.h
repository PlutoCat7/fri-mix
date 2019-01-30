//
//  GBPeripheralDelegateImpl.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/21.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "PacketProfile.h"

//设备活动代理
@protocol GBDeviceActiveGattDelegate <NSObject>

@optional
- (void)deviceActiveGatt:(GattPacket *)gattPacket;

@end

@interface GBPeripheralDelegateImpl : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
//设备活动代理
@property (nonatomic, weak) id<GBDeviceActiveGattDelegate> delegate;

// 设置代理处理的profile
- (void)setTakeoverProfile:(PacketProfile *)packetProfile;

@end

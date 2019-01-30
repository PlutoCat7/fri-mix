//
//  BleGlobal.h
//  GB_Football
//
//  Created by weilai on 16/3/11.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#ifndef BleGlobal_h
#define BleGlobal_h

#import <CoreBluetooth/CoreBluetooth.h>

#define member_size(type, member) sizeof(((type *)0)->member)

//XXXX091E-5084-40D0-A0B5-35853EB08309
#define PUNCHTHROUGHDESIGN_128_UUID(uuid16) uuid16 @"091E-5084-40D0-A0B5-35853EB08309"
#define GLOBAL_PACKET_SERVICE_UUID                            @"FFF0"
#define GLOBAL_PACKET_COMMOND_CHARACTERISTIC_UUID             PUNCHTHROUGHDESIGN_128_UUID(@"B9E3")
#define GLOBAL_PACKET_NOTIFY_CHARACTERISTIC_UUID              PUNCHTHROUGHDESIGN_128_UUID(@"BAE3")
#define GLOBAL_PACKET_NOTIFY_NEW_VERSION_CHARACTERISTIC_UUID  @"B9E30A1E-5084-40D0-A0B5-35853EB08309"  //新版手环

#define Notification_DeviceCheck @"Notification_DeviceCheck"
#define Notification_Bluetooth_Invalid_Command @"Notification_Bluetooth_Invalid_Command"

static const NSTimeInterval kWriteTimeInterval = 10.0;
static const NSTimeInterval kReadTimeInterval = 10.0;

typedef void (^ReadProgressBlock)(CGFloat progress);
typedef void (^ReadMultiServiceBlock)(id data, id sourceData, NSError *error);
typedef void (^ReadServiceBlock)(id data, NSError *error);
typedef void (^WriteServiceBlock)(NSError *error);

typedef enum
{
    /**
     *  An input argument was invalid
     */
    GattErrors_InvalidArgument = 0,
    /**
     * No connect device
     */
    GattErrors_NotConnected,
    /**
     * sync data
     */
    GattErrors_SyncData,
    /**
     * exit sync
     */
    GattErrors_ExitSync,
    /**
     * empty data
     */
    GattErrors_EmptyData,
    /**
     * parse data fail
     */
    GattErrors_PaserFail,
    
    
} GattError;

typedef enum
{
    /**
     *  An input argument was invalid
     */
    BeanErrors_InvalidArgument = 0,
    /**=
     *  Bluetooth is not turned on
     */
    BeanErrors_BluetoothNotOn,
    /**
     *  The bean is not connected
     */
    BeanErrors_NotConnected,
    /**
     *  No Peripheral discovered with corresponding UUID
     */
    BeanErrors_NoPeriphealDiscovered,
    /**
     *  Device with UUID already connected to this Bean
     */
    BeanErrors_AlreadyConnected,
    /**
     *  A device with this UUID is in the process of being connected to
     */
    BeanErrors_AlreadyConnecting,
    /**
     *  The device's current state is not eligible for a connection attempt
     */
    BeanErrors_DeviceNotEligible,
    /**
     *  No device with this UUID is currently connected
     */
    BeanErrors_FailedDisconnect,
    /**
     *  需要先连接蓝牙设备
     */
    BeanErrors_NeedConnect,
    /**
     *  设备连接失败
     */
    BeanErrors_FailedConnect,
    /**
     * 扫描设备超时
     */
    BeanErrors_ScanTimeOut,
    /**
     * 扫描连接超时
     */
    BeanErrors_ConnectTimeOut,
    
} BeanError;

#endif /* BleGlobal_h */

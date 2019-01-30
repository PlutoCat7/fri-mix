//
//  GBBleEnums.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#ifndef GBBleEnums_h
#define GBBleEnums_h

// 设备连接状态
typedef enum
{
    /**
     *  Used for initialization and unknown error states
     */
    BeanState_Unknown = 0,
    /**
     *  Bean has been discovered by a central
     */
    BeanState_Discovered,
    /**
     *  Bean is attempting to connect with a central
     */
    BeanState_AttemptingConnection,
    /**
     *  Bean is undergoing validation,暂时不用
     */
    BeanState_AttemptingValidation,
    /**
     *  Bean is connected
     */
    BeanState_ConnectedAndValidated,
    /**
     *  Bean is disconnecting
     */
    BeanState_AttemptingDisconnection
    
} BeanState;

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
     *
     */
    BeanErrors_Cancel,
    
} BeanError;

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
    /**
     * operation fail
     */
    GattErrors_OperateFail,
    /**
     * no support
     */
    GattErrors_NoSupport
    
    
} GattError;


// 手环操作状态
typedef enum {
    BleOptState_Success = 0,
    BleOptState_Fail = 1,
    
} BleState;

// 手环模式
typedef enum {
    BleModel_None = -1,
    BleModel_Common = 0,
    BleModel_Sport = 1,
    
} BleModel;

// 手环gps状态
typedef enum {
    BleGpsState_None = -1,
    BleGpsState_Doing = 0,
    BleGpsState_Success = 1,
    BleGpsState_NotStart = 2
} BleGpsState;

// 发送找手环的状态
typedef enum {
    BleFindState_Stop = 0,
    BleFindState_Find = 1,
} BleFindState;

#endif /* GBBleEnums_h */

//
//  iBeaconInfo.h
//  GB_Football
//
//  Created by wsw on 16/8/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

@import CoreBluetooth;
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    iBeaconStatus_Unknow = -1,
    iBeaconStatus_Searching = 0,    //搜星中
    iBeaconStatus_Sport = 1,        //足球模式，搜查成功
    iBeaconStatus_Normal = 2,       //日常模式
    iBeaconStatus_Run_Entering = 4,       //正在进入跑步模式
    iBeaconStatus_Run = 5,       //跑步模式
} iBeaconStatus;

typedef enum : NSUInteger {
    iBeaconVersion_None = 0,
    iBeaconVersion_T_Goal = 1,      //tgoal
    iBeaconVersion_T_Goal_S = 2,    //里皮版
} iBeaconVersion;

typedef enum : NSUInteger {
    iBeaconCharge_None = 0,
    iBeaconCharge_Common = 1,      //未充电
    iBeaconCharge_Charging = 2,    //充电中
} iBeaconChargeType;

@interface iBeaconInfo : NSObject

@property (nonatomic, copy) NSString *uniqueUUID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger rssi;
@property (nonatomic, assign) iBeaconStatus status;
@property (nonatomic, assign) iBeaconVersion t_goal_Version;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, assign) NSInteger battery;
@property (nonatomic, copy) NSString *firewareVersion;
@property (nonatomic, copy) NSString *deviceVersion;
@property (nonatomic, assign) iBeaconChargeType chargeType;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral mac:(NSString *)mac;

- (BOOL)isValid;

@end

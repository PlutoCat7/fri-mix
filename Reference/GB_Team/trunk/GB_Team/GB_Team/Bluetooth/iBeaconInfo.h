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
    iBeaconVersion_None = 0,
    iBeaconVersion_T_Goal = 1,      //tgoal
    iBeaconVersion_T_Goal_S = 2,    //里皮版
} iBeaconVersion;

@interface iBeaconInfo : NSObject

@property (nonatomic, copy) NSString *uniqueUUID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger rssi;
@property (nonatomic, assign) iBeaconVersion t_goal_Version;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, assign) NSInteger battery;
@property (nonatomic, copy) NSString *firewareVersion;
@property (nonatomic, copy) NSString *firewareDate;
@property (nonatomic, copy) NSString *deviceVersion;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

- (BOOL)isValid;

@end

@interface iBeaconConnectObject : NSObject

@end

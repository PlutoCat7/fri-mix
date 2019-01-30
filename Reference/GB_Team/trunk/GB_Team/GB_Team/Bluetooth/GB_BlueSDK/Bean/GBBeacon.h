//
//  GBBeacon.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//
@import CoreBluetooth;
#import <Foundation/Foundation.h>

@interface GBBeacon : NSObject

@property (nonatomic, copy) NSString *uniqueUUID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger rssi;
    
@property (nonatomic, strong) CBPeripheral *peripheral;


- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
    
- (BOOL)isValid;
    
@end

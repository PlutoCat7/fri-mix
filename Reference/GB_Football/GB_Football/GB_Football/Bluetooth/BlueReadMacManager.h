//
//  BlueReadMacManager.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

@interface BlueReadMacManager : NSObject

+ (BlueReadMacManager *)sharedManager;

- (void)readMacWithPeripheralList:(NSArray<CBPeripheral *> *)peripheralList manager:(CBCentralManager *)manager handler:(void(^)(NSArray<NSString *> *macList))handler;

@end

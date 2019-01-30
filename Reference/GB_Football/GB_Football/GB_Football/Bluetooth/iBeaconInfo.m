//
//  iBeaconInfo.m
//  GB_Football
//
//  Created by wsw on 16/8/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "iBeaconInfo.h"
#import "BleGlobal.h"

@implementation iBeaconInfo

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral mac:(NSString *)mac
{
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _name = peripheral.name;
        _uniqueUUID = peripheral.identifier.UUIDString;
        _rssi = -1;
        _status = iBeaconStatus_Unknow;
        _address = [mac lowercaseString];
    }
    return self;
}

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if(self=[super init]){
        
        _peripheral = peripheral;
        _name = peripheral.name;
        _uniqueUUID = peripheral.identifier.UUIDString;
        _rssi = [RSSI integerValue];
        _status = iBeaconStatus_Unknow;
        
        BOOL isWechat = NO;
        NSArray *servies = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
        NSData *addrData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        for (CBUUID *uuid in servies) {
            if ([uuid isEqual:[CBUUID UUIDWithString:GLOBAL_WECHAT_SERVICE_UUID]]) {
                isWechat = YES;
            }
        }
        
        if (isWechat && addrData != nil && addrData.length >= 8) {
            Byte *bytes = (Byte *)[addrData bytes];
            NSString *hexStr = @"";
            for (int index = 2; index < 8; index++) {
                NSString *newHexStr = [NSString stringWithFormat:@"%02x", bytes[index]&0xff];
                
                if (index == 2) {
                    hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
                } else {
                    hexStr = [NSString stringWithFormat:@"%@:%@", hexStr, newHexStr];
                }
            }
            _address = [hexStr lowercaseString];
            
        } else if (addrData != nil && addrData.length >= 6) {
            Byte *bytes = (Byte *)[addrData bytes];
            NSString *hexStr = @"";
            for (int index = 6; index > 0; index--) {
                NSString *newHexStr = [NSString stringWithFormat:@"%02x", bytes[index - 1]&0xff];
                
                if (index == 6) {
                    hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
                } else {
                    hexStr = [NSString stringWithFormat:@"%@:%@", hexStr, newHexStr];
                }
            }
            _address = [hexStr lowercaseString];
        }
        
    }
    
    return self;
}

- (BOOL)isValid {
    
    GBLog(@"手环:%@:%@", self.name, self.address);
    if ([NSString stringIsNullOrEmpty:self.uniqueUUID] || [NSString stringIsNullOrEmpty:self.address] || !self.peripheral) {
        return NO;
    }
    if (![self.name containsString:@"T-Goal"]) {
        return NO;
    }
    return YES;
}

@end

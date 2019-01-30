//
//  GBBeacon.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBBeacon.h"

@implementation GBBeacon

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
        
    if(self=[super init]){
            
        _peripheral = peripheral;
        _name = peripheral.name;
        _uniqueUUID = peripheral.identifier.UUIDString;
        _rssi = [RSSI integerValue];
            
        NSData *addrData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        if (addrData != nil && addrData.length >= 6) {
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
    
    if (!self.uniqueUUID || !self.address || !self.peripheral) {
        return NO;
    }
    if (![self.name containsString:@"T-Goal"]) {
        return NO;
    }
    return YES;
}

@end

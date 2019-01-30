//
//  iBeaconInfo.m
//  GB_Football
//
//  Created by wsw on 16/8/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "iBeaconInfo.h"

@implementation iBeaconInfo

- (void)setDeviceVersion:(NSString *)deviceVersion {
    
    _deviceVersion = deviceVersion;
    if ([deviceVersion floatValue]+0.01>=2) {
        self.t_goal_Version = iBeaconVersion_T_Goal_S;
    }else {
        self.t_goal_Version = iBeaconVersion_T_Goal;
    }
}

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
    
    GBLog(@"手环:%@:%@", self.name, self.address);
    if (!self.uniqueUUID || !self.address || !self.peripheral) {
        return NO;
    }
    if (![self.name containsString:@"T-Goal"]) {
        return NO;
    }
    return YES;
}


@end

@implementation iBeaconConnectObject

@end

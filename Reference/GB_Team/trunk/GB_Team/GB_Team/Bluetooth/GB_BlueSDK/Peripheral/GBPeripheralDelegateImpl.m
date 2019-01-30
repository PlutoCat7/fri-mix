//
//  GBPeripheralDelegateImpl.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/21.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBPeripheralDelegateImpl.h"

#import "GBBleConstants.h"

@interface GBPeripheralDelegateImpl() <CBPeripheralDelegate,
PacketProfileDelegate>

@property (nonatomic, strong) CBService *packetService;
@property (nonatomic, strong) CBCharacteristic *packetCharacteristic;  //写数据
@property (nonatomic, strong) CBCharacteristic *notifyCharacteristic;  //读数据

@property (nonatomic, strong) GattPacket *willSendPacket;  //即将写入的数据

@property (nonatomic, strong) PacketProfile *packetProfile;

@end

@implementation GBPeripheralDelegateImpl

- (void)dealloc
{
    
}

#pragma mark - Public
- (void)setTakeoverProfile:(PacketProfile *)packetProfile {
    if (self.packetProfile) {
        self.packetProfile.delegate = nil;
    }
    
    self.packetProfile = packetProfile;
    if (self.packetProfile) {
        self.packetProfile.delegate = self;
    }
}

#pragma mark - PacketProfileDelegate

- (void)sendPacket:(GattPacket *)gattPacket {
    
    self.willSendPacket = gattPacket;
    if (![self isValid]) {
        [self validate];
    }else {
        [self notifyValidity];
    }
}

#pragma mark CBPeripheralDelegate - callbacks
////////////////  CBPeripheralDeligate Callbacks ////////////////////////////
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    
    GBBleLog(@"didDiscoverServices");
    if (!error) {
        if(self.peripheral.services) {
            // Discover characteristics of found services
            for (CBService * service in self.peripheral.services) {
                // Save Gatt Serail service
                if ([service.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_SERVICE_UUID]]) {
                    
                    // Save serial pass service
                    self.packetService = service;
                    
                    //Check if characterisics are already found.
                    [self processCharacteristics];
                    
                    //If all characteristics are found
                    if (self.notifyCharacteristic && self.packetCharacteristic) {
                        if (self.notifyCharacteristic.isNotifying) {
                            [self notifyValidity];
                        } else {
                            //Set characteristic to notify
                            [self.peripheral setNotifyValue:YES forCharacteristic:self.notifyCharacteristic];
                            //Wait until the notification characteristic is registered successfully as "notify" and then alert delegate that device is valid
                        }
                        
                    } else {
                        // Find characteristics of service
                        NSArray * characteristics = [NSArray arrayWithObjects:
                                                     [CBUUID UUIDWithString:GLOBAL_PACKET_COMMOND_CHARACTERISTIC_UUID],
                                                     [CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_CHARACTERISTIC_UUID],
                                                     [CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_NEW_VERSION_CHARACTERISTIC_UUID],
                                                     nil];
                        [self.peripheral discoverCharacteristics:characteristics forService:service];
                    }
                    break;
                }
            }
        }
        
    } else {
        //Alert Delegate
        GBBleLog(@"Don't discover service");
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    GBBleLog(@"didDiscoverCharacteristicsForService");
    if (!error) {
        if ([service isEqual:self.packetService]) {
            [self processCharacteristics];
            
            if (self.notifyCharacteristic) {
                if (self.notifyCharacteristic.isNotifying) {
                    [self notifyValidity];
                    
                } else {
                    //Set characteristic to notify
                    [self.peripheral setNotifyValue:YES forCharacteristic:self.notifyCharacteristic];
                    //Wait until the notification characteristic is registered successfully as "notify" and then alert delegate that device is valid
                }
            } else {
                // Could not find all characteristics!
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:@"Could not find all GATT Serial Pass characteristics" forKey:NSLocalizedDescriptionKey];
                NSError* verificationerror = [NSError errorWithDomain:@"Bluetooth" code:100 userInfo:errorDetail];
                GBBleLog(@"%@", verificationerror.localizedDescription);
            }
            
        } else {
            //Alert Delegate
        }
        
    } else {
        //Alert Delegate
        GBBleLog(@"%@", error.localizedDescription);
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    GBBleLog(@"%@ didUpdateValueForCharacteristic", [self class]);
    if (!error) {
        GBBleLog(@"characteristic value:%@", [characteristic value]);
        if ([characteristic isEqual:self.notifyCharacteristic]) {
            NSError *error;
            GattPacket *packet = [[GattPacket alloc] initWithData:[characteristic value] error:&error];
            if (!packet || error) {
                if (self.packetProfile && [self.packetProfile respondsToSelector:@selector(gattPacketProfile:error:)]) {
                    [self.packetProfile gattPacketProfile:self.packetProfile error:error];
                }
                
            } else if ([GattPacket isDeviceActive:packet]) {
                // 设备主动发出的指令
                if (self.delegate && [self.delegate respondsToSelector:@selector(deviceActiveGatt:)]) {
                    [self.delegate deviceActiveGatt:packet];
                }
                
            } else {
                if ([self.packetProfile respondsToSelector:@selector(gattPacketProfile:packet:)]) {
                    [self.packetProfile gattPacketProfile:self.packetProfile packet:packet];
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    GBBleLog(@"didWriteValueForCharacteristic");
    //Is the serial pass characteristic
    
    if ([self.packetProfile respondsToSelector:@selector(gattPacketProfileWriteNotify:)]) {
        [self.packetProfile gattPacketProfileWriteNotify:self.packetProfile];
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    GBBleLog(@"didUpdateNotificationStateForCharacteristic");
    
    if (!error) {
        if ([characteristic isEqual:self.notifyCharacteristic]) {
            //Alert Delegate that device is connected. At this point, the device should be added to the list of connected devices.
            GBBleLog(@"notifyCharacteristic");
            [self notifyValidity];
            
        } else {
            GBBleLog(@"%@", characteristic);
        }
        
    } else {
        GBBleLog(@"%@", error.localizedDescription);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    GBBleLog(@"didDiscoverDescriptorsForCharacteristic");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    
    GBBleLog(@"didUpdateValueForDescriptor");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    
    GBBleLog(@"didWriteValueForDescriptor");
}

#pragma mark - Private

- (void)processCharacteristics {
    
    if(self.packetService && self.packetService.characteristics){
        for(CBCharacteristic* characteristic in self.packetService.characteristics){
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_COMMOND_CHARACTERISTIC_UUID]]){
                self.packetCharacteristic = characteristic;
                
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_CHARACTERISTIC_UUID]]) {
                self.notifyCharacteristic = characteristic;
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_NEW_VERSION_CHARACTERISTIC_UUID]]) {
                self.notifyCharacteristic = characteristic;
            }
        }
    }
}

- (void)validate {
    
    // Discover services
    if(self.peripheral.state == CBPeripheralStateConnected) {
        [self.peripheral discoverServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:GLOBAL_PACKET_SERVICE_UUID], nil]];
    }
}

- (BOOL)isValid {
    
    BOOL valid = (self.packetService && self.packetCharacteristic && self.notifyCharacteristic && self.notifyCharacteristic.isNotifying)?YES:NO;
    
    return valid;
}

- (void)notifyValidity {
    
    if (self.willSendPacket) {
        [self.peripheral writeValue:self.willSendPacket.data forCharacteristic:self.packetCharacteristic type:CBCharacteristicWriteWithResponse];
        self.willSendPacket = nil;
    }
}

#pragma mark - Setter Getter

- (void)setPeripheral:(CBPeripheral *)peripheral {
    //清除上个手环的记录
    self.peripheral.delegate = nil;
    self.packetService = nil;
    self.packetCharacteristic = nil;
    self.notifyCharacteristic = nil;
    self.packetProfile = nil;
    
    peripheral.delegate = self;
    _peripheral = peripheral;
    
    [self validate];
}

@end

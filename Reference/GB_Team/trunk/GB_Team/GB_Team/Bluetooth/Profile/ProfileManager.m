//
//  ProfileManager.m
//  GB_Football
//
//  Created by 王时温 on 2016/11/3.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "ProfileManager.h"

@interface ProfileManager () <
CBPeripheralDelegate,
PacketProfileDelegate>

@property (nonatomic, strong) CBService *packetService;
@property (nonatomic, strong) CBCharacteristic *packetCharacteristic;  //写数据
@property (nonatomic, strong) CBCharacteristic *notifyCharacteristic;  //读数据
@property (nonatomic, strong) GattPacket *willSendPacket;  //即将写入的数据

@property (nonatomic, strong) NSMutableArray<__kindof PacketProfile *> *profileList;

@end

@implementation ProfileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _profileList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Public

- (void)addProfile:(__kindof PacketProfile *)profile {
    
    if (![self.profileList containsObject:profile]) {
        profile.delegate = self;
        [self.profileList addObject:profile];
    }
}

- (void)addProfileWithArray:(NSArray<__kindof PacketProfile *> *)list {
    
    for (PacketProfile *profile in list) {
        [self addProfile:profile];
    }
}

- (void)removeProfile:(__kindof PacketProfile *)profile {
    
    if ([self.profileList containsObject:profile]) {
        profile.delegate = nil;
        [profile stopTask];
        [self.profileList removeObject:profile];
    }
}

- (void)removeAllProfile{
    
    for (PacketProfile *profile in self.profileList) {
        [self removeProfile:profile];
    }
}

- (void)cleanTask {
    
    GBLog(@"profile 任务清空！");
    self.willSendPacket = nil;
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
    
    GBLog(@"didDiscoverServices");
    if (!error) {
        if(self.peripheral.services)
        {
            // Discover characteristics of found services
            for (CBService * service in self.peripheral.services) {
                // Save Gatt Serail service
                if ([service.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_SERVICE_UUID]]) {
                    
                    // Save serial pass service
                    self.packetService = service;
                    
                    //Check if characterisics are already found.
                    [self processCharacteristics];
                    
                    //If all characteristics are found
                    if(self.notifyCharacteristic && self.packetCharacteristic)
                    {
                        if(self.notifyCharacteristic.isNotifying){
                            [self notifyValidity];
                        }else{
                            //Set characteristic to notify
                            [self.peripheral setNotifyValue:YES forCharacteristic:self.notifyCharacteristic];
                            //Wait until the notification characteristic is registered successfully as "notify" and then alert delegate that device is valid
                        }
                    }else{
                        // Find characteristics of service
                        NSArray * characteristics = [NSArray arrayWithObjects:
                                                     [CBUUID UUIDWithString:GLOBAL_PACKET_COMMOND_CHARACTERISTIC_UUID],
                                                     [CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_CHARACTERISTIC_UUID],[CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_NEW_VERSION_CHARACTERISTIC_UUID],
                                                     nil];
                        [self.peripheral discoverCharacteristics:characteristics forService:service];
                    }
                    break;
                }
            }
        }
        
    } else {
        //Alert Delegate
        GBLog(@"手环无服务");
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    GBLog(@"didDiscoverCharacteristicsForService");
    if (!error) {
        if ([service isEqual:self.packetService]) {
            [self processCharacteristics];
            
            if (self.notifyCharacteristic){
                if(self.notifyCharacteristic.isNotifying){
                    [self notifyValidity];
                    
                }else{
                    //Set characteristic to notify
                    [self.peripheral setNotifyValue:YES forCharacteristic:self.notifyCharacteristic];
                    //Wait until the notification characteristic is registered successfully as "notify" and then alert delegate that device is valid
                }
            }else{
                // Could not find all characteristics!
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:@"Could not find all GATT Serial Pass characteristics" forKey:NSLocalizedDescriptionKey];
                NSError* verificationerror = [NSError errorWithDomain:@"Bluetooth" code:100 userInfo:errorDetail];
                GBLog(@"%@", verificationerror.localizedDescription);
            }
            
        } else {
            //Alert Delegate
        }
        
    } else {
        //Alert Delegate
        GBLog(@"%@", error.localizedDescription);
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (!error) {
        //GBLog(@"%@", [characteristic value]);
        if ([characteristic isEqual:self.notifyCharacteristic]) {
            NSError *error;
            //返回数据为空，不处理
            NSData *value = [characteristic value];
            if (value.length < 3 || !value) {
                return;
            }
            GattPacket *packet = [[GattPacket alloc] initWithData:[characteristic value] error:&error];
            if (!packet || error) {
                for (PacketProfile *profile in self.profileList) {
                    if ([profile respondsToSelector:@selector(gattPacketProfile:error:)]) {
                        [profile gattPacketProfile:profile error:error];
                    }
                }
            } else {
                for (PacketProfile *profile in self.profileList) {
                    if ([profile respondsToSelector:@selector(gattPacketProfile:packet:)]) {
                        [profile gattPacketProfile:profile packet:packet];
                    }
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    //GBLog(@"didWriteValueForCharacteristic");
    //Is the serial pass characteristic
    
    for (PacketProfile *profile in self.profileList) {
        if ([profile respondsToSelector:@selector(gattPacketProfileWriteNotify:)]) {
            [profile gattPacketProfileWriteNotify:profile];
        }
    }
}

- (void)peripheral:(CBPeripheral *)aPeripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    GBLog(@"didUpdateNotificationStateForCharacteristic");
    if(!error)
    {
        if([characteristic isEqual:self.notifyCharacteristic]) {
            //Alert Delegate that device is connected. At this point, the device should be added to the list of connected devices.
            GBLog(@"notifyCharacteristic");
            [self notifyValidity];
            
        } else {
            GBLog(@"%@", characteristic);
        }
        
    }else{
        GBLog(@"%@", error.localizedDescription);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    GBLog(@"didDiscoverDescriptorsForCharacteristic");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    
    GBLog(@"didUpdateValueForDescriptor");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    
    GBLog(@"didWriteValueForDescriptor");
}

#pragma mark - Private

- (void)processCharacteristics {
    
    if(self.packetService && self.packetService.characteristics){
        for(CBCharacteristic* characteristic in self.packetService.characteristics){
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_COMMOND_CHARACTERISTIC_UUID]]){
                self.packetCharacteristic = characteristic;
                
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_CHARACTERISTIC_UUID]]) {
                self.notifyCharacteristic = characteristic;
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:GLOBAL_PACKET_NOTIFY_NEW_VERSION_CHARACTERISTIC_UUID]]) {
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
    
    peripheral.delegate = self;
    _peripheral = peripheral;
    
    [self validate];
}


@end

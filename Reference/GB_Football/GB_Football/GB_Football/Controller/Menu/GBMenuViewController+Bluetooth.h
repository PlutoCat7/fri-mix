//
//  GBMenuViewController+Bluetooth.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMenuViewController.h"

@interface GBMenuViewController (Bluetooth)

- (void)initBluetooth;

- (void)connectWristbandWithMac:(NSString *)mac;

- (void)updateAboutBlutoothUI;

- (void)addBluetoothNotification;

@end

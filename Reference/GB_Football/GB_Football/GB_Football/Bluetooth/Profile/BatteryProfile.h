//
//  BatteryProfile.h
//  GB_Football
//
//  Created by weilai on 16/3/11.
//  Copyright © 2016年 GoBrother. All rights reserved.
//  读取电量

#import "PacketProfile.h"

@interface BatteryProfile : PacketProfile

- (void)readBattery:(ReadServiceBlock)serviceBlock;

@end



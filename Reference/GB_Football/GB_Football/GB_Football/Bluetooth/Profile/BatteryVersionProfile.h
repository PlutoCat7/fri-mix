//
//  BatteryVersionProfile.h
//  GB_Football
//
//  Created by weilai on 16/6/14.
//  Copyright © 2016年 GoBrother. All rights reserved.
//  读取电量版本日期

#import "PacketProfile.h"

@interface BatteryVersionProfile : PacketProfile

- (void)readBatteryVersion:(ReadServiceBlock)serviceBlock;

@end

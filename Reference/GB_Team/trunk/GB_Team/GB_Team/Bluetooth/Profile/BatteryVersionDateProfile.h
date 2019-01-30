//
//  BatteryVersionDateProfile.h
//  GB_Football
//
//  Created by weilai on 16/6/14.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PacketProfile.h"

@interface BatteryVersionDateProfile : PacketProfile

- (void)readBatteryVersionDate:(ReadServiceBlock)serviceBlock;

@end

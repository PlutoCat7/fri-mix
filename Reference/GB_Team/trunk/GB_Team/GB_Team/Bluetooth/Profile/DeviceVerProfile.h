//
//  DeviceVerProfile.h
//  GB_Football
//
//  Created by 王时温 on 2017/3/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface DeviceVerProfile : PacketProfile

- (void)readDeviceVersion:(ReadServiceBlock)serviceBlock;

@end

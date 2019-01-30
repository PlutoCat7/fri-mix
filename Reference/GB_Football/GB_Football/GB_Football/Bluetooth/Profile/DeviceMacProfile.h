//
//  DeviceMacProfile.h
//  GB_Football
//
//  Created by gxd on 17/6/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface DeviceMacProfile : PacketProfile

- (void)readDeviceMac:(ReadServiceBlock)serviceBlock;

@end

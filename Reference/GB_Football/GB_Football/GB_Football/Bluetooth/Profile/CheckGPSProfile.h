//
//  CheckGPSProfile.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  检查搜星状态

#import "PacketProfile.h"

@interface CheckGPSProfile : PacketProfile

- (void)checkGPSWithServiceBlock:(ReadServiceBlock)serviceBlock;

@end

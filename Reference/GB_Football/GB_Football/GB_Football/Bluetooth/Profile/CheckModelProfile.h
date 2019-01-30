//
//  CheckModelProfile.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  检测手环当前模式

#import "PacketProfile.h"

@interface CheckModelProfile : PacketProfile

- (void)checkModelWithServiceBlock:(ReadServiceBlock)serviceBlock;

@end

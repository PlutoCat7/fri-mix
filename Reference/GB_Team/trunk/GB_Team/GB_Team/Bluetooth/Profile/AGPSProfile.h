//
//  AGPSProfile.h
//  GB_Football
//
//  Created by wsw on 2016/10/28.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  星历数据写入

#import "PacketProfile.h"

@interface AGPSProfile : PacketProfile

- (void)doAGPSProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock;

- (void)cancelAGPS;

@end

//
//  SportProfile.h
//  GB_Football
//
//  Created by weilai on 16/3/20.
//  Copyright © 2016年 GoBrother. All rights reserved.
//  读取手环运动数据

#import "PacketProfile.h"

@interface SportProfile : PacketProfile

- (void)sendSportProfile:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock;

@end

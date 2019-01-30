//
//  DailyMutableProfile.h
//  GB_Football
//
//  Created by weilai on 16/4/11.
//  Copyright © 2016年 GoBrother. All rights reserved.
//  手环日常数据读取

#import "PacketProfile.h"

@interface DailyMutableProfile : PacketProfile

- (void)sendMutableDailyProfile:(NSArray *)dateArray serviceBlock:(ReadServiceBlock)serviceBlock;

@end

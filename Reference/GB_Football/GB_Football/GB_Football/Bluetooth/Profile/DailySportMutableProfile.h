//
//  DailySportMutableProfile.h
//  GB_Football
//
//  Created by gxd on 17/6/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface DailySportMutableProfile : PacketProfile

- (void)sendMutableDailyProfile:(NSArray *)dateArray serviceBlock:(ReadServiceBlock)serviceBlock;

@end

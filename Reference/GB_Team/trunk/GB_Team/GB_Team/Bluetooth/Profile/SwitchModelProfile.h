//
//  SwitchModelProfile.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  切换手环模式

#import "PacketProfile.h"

@interface SwitchModelProfile : PacketProfile

/**
 切换手环模式

 @param index 0：普通模式  1：运动模式
 @param serviceBlock 回调block
 */
- (void)switchModelWithIndx:(NSInteger)index serviceBlock:(WriteServiceBlock)serviceBlock;

@end

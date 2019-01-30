//
//  SearchProfile.h
//  GB_Team
//
//  Created by wsw on 2016/9/30.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  查找手环

#import "PacketProfile.h"

@interface SearchProfile : PacketProfile

/**
 寻找手环

 @param serviceBlock 回调
 @param isStart YES：寻找手环  NO: 停止寻找手环
 */
- (void)searchWrist:(ReadServiceBlock)serviceBlock isStart:(BOOL)isStart;

@end

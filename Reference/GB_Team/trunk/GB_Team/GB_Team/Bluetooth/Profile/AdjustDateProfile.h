//
//  AdjustDateProfile.h
//  GB_Football
//
//  Created by weilai on 16/6/14.
//  Copyright © 2016年 GoBrother. All rights reserved.
//  设置手环日期

#import "PacketProfile.h"

@interface AdjustDateProfile : PacketProfile

- (void)adjustDate:(NSDate *)date serviceBlock:(WriteServiceBlock)serviceBlock;

@end

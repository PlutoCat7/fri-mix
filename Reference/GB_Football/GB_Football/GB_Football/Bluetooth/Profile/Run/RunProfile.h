//
//  RunProfile.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface RunProfile : PacketProfile

- (void)readRunDataWithMonth:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock;

@end

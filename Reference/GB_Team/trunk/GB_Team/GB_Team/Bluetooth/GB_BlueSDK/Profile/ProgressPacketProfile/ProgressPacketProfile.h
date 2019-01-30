//
//  ProgressPacketProfile.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/22.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PacketProfile.h"

@interface ProgressPacketProfile : PacketProfile

@property (nonatomic, copy) ResultProgressBlock progressBlock;

// 执行progress profile
- (void)executeProgressProfile:(ResultServiceBlock)serviceBlock progressBlock:(ResultProgressBlock)progressBlock;

@end

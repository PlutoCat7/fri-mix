//
//  UpdateProfile.h
//  GB_Football
//
//  Created by weilai on 16/4/19.
//  Copyright © 2016年 GoBrother. All rights reserved.
//  更新手环固件

#import "PacketProfile.h"

@interface UpdateProfile : PacketProfile

- (void)sendUpdateProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock;

@end

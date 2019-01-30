//
//  VersionProfile.h
//  GB_Team
//
//  Created by 王时温 on 2016/11/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface VersionProfile : PacketProfile

- (void)readVersion:(ReadServiceBlock)serviceBlock;

@end

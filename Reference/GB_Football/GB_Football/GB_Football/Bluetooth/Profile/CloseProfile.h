//
//  CloseProfile.h
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface CloseProfile : PacketProfile

- (void)closeWithserviceBlock:(WriteServiceBlock)serviceBlock;

@end

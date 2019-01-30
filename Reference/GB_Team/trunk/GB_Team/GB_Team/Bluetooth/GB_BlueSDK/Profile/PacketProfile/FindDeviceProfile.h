//
//  FindDeviceProfile.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/27.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PacketProfile.h"

@interface FindDeviceProfile : PacketProfile

- (instancetype)initWithFindState:(BleFindState)findState;

@end

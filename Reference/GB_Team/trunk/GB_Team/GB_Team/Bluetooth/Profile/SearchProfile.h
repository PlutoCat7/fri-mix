//
//  SearchProfile.h
//  GB_Team
//
//  Created by wsw on 2016/9/30.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface SearchProfile : PacketProfile

- (void)searchWrist:(ReadServiceBlock)serviceBlock;

@end

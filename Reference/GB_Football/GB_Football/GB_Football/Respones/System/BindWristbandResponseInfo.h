//
//  BindWristbandResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "UserResponseInfo.h"

///手环绑定和解绑
@interface BindWristbandResponseInfo : GBResponseInfo

@property (nonatomic, strong) WristbandInfo *data;

@end

//
//  UserResponse.h
//  GB_Video
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "UserInfo.h"

@interface UserResponse : GBResponseInfo

@property (nonatomic, strong) UserInfo *data;

@end

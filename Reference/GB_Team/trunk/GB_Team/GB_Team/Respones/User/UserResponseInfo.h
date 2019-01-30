//
//  UserResponseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface UserInfo : GBResponseInfo

@property (nonatomic, copy  ) NSString      *sid;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger     userId;
//待完成的比赛id
@property (nonatomic, assign) NSInteger     matchId;

@end


@interface UserResponseInfo : GBResponseInfo

@property (nonatomic, strong) UserInfo *data;

@end

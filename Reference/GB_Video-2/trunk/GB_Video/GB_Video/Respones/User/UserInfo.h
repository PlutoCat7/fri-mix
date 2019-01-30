//
//  UserInfo.h
//  GB_Video
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface UserInfo : GBResponseInfo

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy  ) NSString      *nick;
@property (nonatomic, assign) SexType       sexType;
@property (nonatomic, copy  ) NSString      *imageUrl;
@property (nonatomic, assign) NSInteger     provinceId;
@property (nonatomic, assign) NSInteger     cityId;
@property (nonatomic, assign) NSInteger     regionId;

@end

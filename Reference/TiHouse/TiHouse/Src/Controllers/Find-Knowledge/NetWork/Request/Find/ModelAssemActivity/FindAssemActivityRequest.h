//
//  FindAssemActivityRequest.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "FindAssemActivityResponse.h"

@interface FindAssemActivityRequest : BaseNetworkRequest

//获取所有进行中的征集
+ (void)getActivityListWithHandler:(RequestCompleteHandler)handler;

//获取征集活动列表(进行中，最多5条) 首页使用
+ (void)getActivityListFiveWithHandler:(RequestCompleteHandler)handler;

+ (void)getActivityInfoWithAssemId:(long)assemId handler:(RequestCompleteHandler)handler;

@end

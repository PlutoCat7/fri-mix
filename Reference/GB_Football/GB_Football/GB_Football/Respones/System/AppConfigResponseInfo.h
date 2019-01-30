//
//  AppConfigResponseInfo.h
//  GB_Football
//
//  Created by gxd on 2017/10/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

//球队活动状态
typedef NS_ENUM(NSUInteger, TeamActState) {
    TeamActState_Close = -1,
    TeamActState_Unknow = 0,
    TeamActState_Open = 1,
};

@interface AppConfigInfo : YAHDataResponseInfo

@property (nonatomic, assign) TeamActState showTeamActState;

@end

@interface AppConfigResponseInfo : GBResponseInfo

@property (nonatomic, strong) AppConfigInfo *data;

@end

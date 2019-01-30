//
//  TeamRankResponseInfo.h
//  GB_Football
//
//  Created by gxd on 17/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface TeamRankInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *teamIcon;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) BOOL isTeamMatch; // 是否有球队比赛

@end

@interface TeamRankRespone : YAHActiveObject

@property (nonatomic, strong) NSArray<TeamRankInfo *> *team_list;
@property (nonatomic, strong) TeamRankInfo *my_team;

@end

@interface TeamRankResponseInfo : GBResponseInfo

@property (nonatomic, strong) TeamRankRespone *data;

@end

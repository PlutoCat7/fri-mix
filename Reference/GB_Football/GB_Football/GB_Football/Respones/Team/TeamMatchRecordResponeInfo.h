//
//  TeamMatchRecordResponeInfo.h
//  GB_Football
//
//  Created by gxd on 17/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface TeamMatchInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, copy) NSString *courtName;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, assign) NSInteger tracticsType;
@property (nonatomic, assign) long matchDate;    //创建比赛时间
@property (nonatomic, assign) long matchInterval;    //比赛时长
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger guestScore;
@property (nonatomic, copy) NSString *homeTeam;
@property (nonatomic, copy) NSString *guestTeam;
@property (nonatomic, copy) NSString *cityName;

@end

@interface TeamMatchRecordResponeInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<TeamMatchInfo *> *data;

@end

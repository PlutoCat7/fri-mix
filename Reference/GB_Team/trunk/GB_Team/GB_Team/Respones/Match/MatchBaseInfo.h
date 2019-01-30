//
//  MatchBaseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "YAHDataResponseInfo.h"
#import "TeamResponseInfo.h"

@interface MatchBaseInfo : YAHDataResponseInfo

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, assign) long matchTime;

@property (nonatomic, assign) NSInteger courtId;
@property (nonatomic, copy) NSString *courtName;

@property (nonatomic, assign) long firstStartTime;
@property (nonatomic, assign) long firstEndTime;
@property (nonatomic, assign) long secondStartTime;
@property (nonatomic, assign) long secondEndTime;

@property (nonatomic, strong) TeamInfo *homeTeam;
@property (nonatomic, strong) TeamInfo *guestTeam;
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger guestScore;

@end

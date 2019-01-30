//
//  MatchInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"

@interface MatchInfo : YAHDataResponseInfo

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, assign) long matchTime;

@property (nonatomic, assign) NSInteger courtId;
@property (nonatomic, copy) NSString *courtName;

@property (nonatomic, assign) NSInteger creatorId;
@property (nonatomic, copy) NSString *creatorName;

@property (nonatomic, assign) long firstStartTime;
@property (nonatomic, assign) long firstEndTime;
@property (nonatomic, assign) long secondStartTime;
@property (nonatomic, assign) long secondEndTime;

@property (nonatomic, assign) NSInteger homeTeamId;
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger guestScore;

@property (nonatomic, copy) NSString *homeTeamName;
@property (nonatomic, copy) NSString *guestTeamName;

@end

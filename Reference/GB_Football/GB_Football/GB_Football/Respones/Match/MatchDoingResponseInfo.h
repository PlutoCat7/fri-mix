//  待完成的比赛信息
//  MatchDoingResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface MatchDoingInfo : YAHDataResponseInfo

@property (nonatomic, strong) NSString *match_name;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *court_address;
@property (nonatomic, assign) NSInteger creatorId;
@property (nonatomic, assign) NSInteger joinedCount;
@property (nonatomic, assign) NSInteger match_date;
@property (nonatomic, assign) NSInteger match_id;
@property (nonatomic, assign) GameType type;

//------local property
//记录分时
@property (nonatomic, strong) NSArray<TimeDivisionRecordInfo *> *timeDivisionRecordList;
@property (nonatomic, copy) NSString *host_team;
@property (nonatomic, copy) NSString *follow_team;
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger guestScore;
@property (nonatomic, assign) NSInteger firstStartTime;
@property (nonatomic, assign) NSInteger firstEndTime;
@property (nonatomic, assign) NSInteger secondStartTime;
@property (nonatomic, assign) NSInteger secondEndTime;
@property (nonatomic, assign) NSInteger matchBeginTime;
@property (nonatomic, assign) NSInteger matchEndTime;

@property (nonatomic, strong) NSArray<NSString *> *uriList;
@property (nonatomic, strong) NSArray<NSString *> *videoUriList;

- (void)loadDefaultLocalData;

@end

@interface MatchDoingMessInfo : YAHActiveObject

@property (nonatomic, strong) MatchDoingInfo *match_mess;

@end

@interface MatchDoingResponseInfo : GBResponseInfo

@property (nonatomic, strong) MatchDoingMessInfo *data;

@end

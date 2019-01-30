//
//  MatchBindResponseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface PendingMatchHeadInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, copy) NSString *courtName;
@property (nonatomic, assign) NSInteger createTime;  //比赛创建时间

@end

@interface PendingMatchPlayerListInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger playerId;
@property (nonatomic, assign) NSInteger orderId;   //手环编号
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, copy) NSString *orderName; //手环名称
@property (nonatomic, copy) NSString *mac;

@end

@interface PendingMatchInfo : YAHActiveObject

@property (nonatomic, strong) PendingMatchHeadInfo *matchHeadInfo;
@property (nonatomic, strong) NSArray<PendingMatchPlayerListInfo *> *matchPlayerList;

@end

@interface MatchBindResponseInfo : GBResponseInfo

@property (nonatomic, strong) PendingMatchInfo *data;

@end

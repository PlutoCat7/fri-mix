//
//  MatchNearByListResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//
//附近比赛列表
#import "GBResponseInfo.h"
#import "MatchInfo.h"

@interface MatchNearByListResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<MatchInfo *> *data;

@end

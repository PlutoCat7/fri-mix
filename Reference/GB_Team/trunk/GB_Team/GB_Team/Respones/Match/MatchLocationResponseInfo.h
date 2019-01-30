//
//  MatchLocationResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//
//比赛的坐标数据,生成热点图
#import "GBResponseInfo.h"

@interface MatchLocationInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat lon;
@property (nonatomic, assign) CGFloat lat;

@end

@interface MatchLocationDataInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<MatchLocationInfo *> *firstData;
@property (nonatomic, strong) NSArray<MatchLocationInfo *> *secondData;

@end

@interface MatchLocationResponseInfo : GBResponseInfo

@property (nonatomic, strong) MatchLocationDataInfo *data;

@end

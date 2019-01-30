//
//  MatchLogic.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchLogic : NSObject

+ (void)joinMatchGameWithMatchId:(NSInteger)matchId creatorId:(NSInteger)creatorId handler:(void(^)(NSError *error))handler;

//赛后设置检验时间设置是否正确  0：时间设置异常   1:时间跨天   2：时间正常
+ (NSInteger)sectionsDateCompare:(NSDate *)oneDate twoDate:(NSDate *)twoDate;

//如果时间<=3am, 将日期改为第二天
+ (NSDate *)transferTomorrow:(NSDate *)date;

@end

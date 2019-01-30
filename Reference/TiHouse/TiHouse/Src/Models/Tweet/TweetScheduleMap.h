//
//  TweetScheduleMap.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetSchedule.h"
@interface TweetScheduleMap : NSObject

//最后更新时间
@property (nonatomic, assign) long latesttime;
//用户昵称
@property (nonatomic, copy) NSString *nickname;
//日程内容
@property (nonatomic, retain) TweetSchedule *schedule;

@end

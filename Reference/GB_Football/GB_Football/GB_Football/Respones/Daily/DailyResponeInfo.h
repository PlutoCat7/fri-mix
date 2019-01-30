//
//  DailyResponeInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface DailyInfo : YAHActiveObject

@property (nonatomic, assign) long date;
@property (nonatomic, assign) NSInteger dailyStep;
@property (nonatomic, assign) float dailyDistance;
@property (nonatomic, assign) float dailyConsume;
// 运动
@property (nonatomic, assign) NSInteger sportStep;
@property (nonatomic, assign) float sportDistance;
@property (nonatomic, assign) float sportConsume;

// 跑步
@property (nonatomic, assign) NSInteger runStep;
@property (nonatomic, assign) float runDistance;
@property (nonatomic, assign) float runConsume;

@property (nonatomic, assign, readonly) NSInteger dailyAndRunStep;
@property (nonatomic, assign, readonly) float dailyAndRunDistance;
@property (nonatomic, assign, readonly) float dailyAndRunConsume;
@property (nonatomic, assign, readonly) NSInteger totalStep;
@property (nonatomic, assign, readonly) float totalDistance;
@property (nonatomic, assign, readonly) float totalConsume;

@end

@interface DailyResponeInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<DailyInfo *> *data;

@end

//
//  BluUtility.m
//  GB_Football
//
//  Created by weilai on 16/4/10.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "BluUtility.h"

@implementation BluUtility

+ (void)setUUIDString:(NSString *)uuid withKey:(NSString *)mac {
    
    if ([NSString stringIsNullOrEmpty:uuid]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:mac];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUUIDStringWithKey:(NSString *)mac {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:mac];
}

// 计算日常模式
+ (NSArray *) calDaily:(NSDictionary *)dailyData weight:(float)weight height:(float)height sex:(int)sex {
    NSMutableArray *resultArray = [NSMutableArray new];
    int step = 0;
    double distance = 0;
    double kcal = 0.f;
    
    if (dailyData) {
        NSArray *items = [dailyData objectForKey:@"items"];
        
        if (items && [items count] > 0) {
            for (NSDictionary *itemDict in items) {
                NSInteger duration = [[itemDict objectForKey:@"duration"] integerValue];
                
                int itemStep = 0;
                float itemDistance = 0;
                double itemKCal = 0.f;
                NSArray *stepArr = [itemDict objectForKey:@"steps"];
                if (stepArr && [stepArr count] > 0) {
                    for (NSNumber *number in stepArr) {
                        itemStep += [number integerValue];
                    }
                }
                
                if (itemStep == 0 || duration == 0) {
                    step += itemStep;
                    continue;
                }
                
                // 步频
                double stepSpeed = ((double) itemStep) / ((double) (duration * 60));
                double stepLength = [self calStepLength:stepSpeed weight:weight height:height];
                itemDistance = (double) (stepLength * (double) itemStep);
                //double speed = (double)itemDistance / ((double) (duration * 60));
                
                // 卡路里
                //itemKCal = [self sportTotalCalorie:weight duration:(duration * 60) speed:speed sex:sex];
                itemKCal = 0.0832 * itemDistance;
                
                step += itemStep;
                distance += itemDistance;
                kcal += itemKCal;
            }
        }
    }
    
    [resultArray addObject:[NSNumber numberWithInt:step]];
    [resultArray addObject:[NSNumber numberWithInt:distance]];
    [resultArray addObject:[NSNumber numberWithDouble:kcal]];
    
    return resultArray;
}

+ (NSArray *) calDailySport:(NSDictionary *)dailySportData weight:(float)weight height:(float)height sex:(int)sex {
    NSMutableArray *resultArray = [NSMutableArray new];
    int sportStep = 0;
    double sportDistance = 0;
    double sportKcal = 0.f;
    int runStep = 0;
    double runDistance = 0;
    double runKcal = 0.f;
    
    if (dailySportData) {
        NSArray *items = [dailySportData objectForKey:@"items"];
        
        if (items && [items count] > 0) {
            for (NSDictionary *itemDict in items) {
                
                NSInteger itemStep = [[itemDict objectForKey:@"steps"] integerValue];
                NSInteger duration = [[itemDict objectForKey:@"duration"] integerValue];
                NSInteger type = [[itemDict objectForKey:@"type"] integerValue];
                
                float itemDistance = 0;
                double itemKCal = 0.f;
                
                if (itemStep == 0 || duration == 0) {
                    if (type == 1) {
                        sportStep += itemStep;
                    } else if (type == 3) {
                        runStep += itemStep;
                    }
                    continue;
                }
                
                // 步频
                double stepSpeed = ((double) itemStep) / ((double) (duration));
                double stepLength = [self calStepLength:stepSpeed weight:weight height:height];
                itemDistance = (double) (stepLength * (double) itemStep);
                //double speed = (double)itemDistance / ((double) (duration));
                
                // 卡路里
                //itemKCal = [self sportTotalCalorie:weight duration:(duration) speed:speed sex:sex];
                itemKCal = 0.0832 * itemDistance;
                
                if (type == 1) {//sport
                    sportStep += itemStep;
                    sportDistance += itemDistance;
                    sportKcal += itemKCal;
                }else if (type == 3) {//run
                    runStep += itemStep;
                    runDistance += itemDistance;
                    runKcal += itemKCal;
                }
            }
        }
    }
    
    [resultArray addObject:[NSNumber numberWithInt:sportStep]];
    [resultArray addObject:[NSNumber numberWithInt:sportDistance]];
    [resultArray addObject:[NSNumber numberWithDouble:sportKcal]];
    [resultArray addObject:[NSNumber numberWithInt:runStep]];
    [resultArray addObject:[NSNumber numberWithInt:runDistance]];
    [resultArray addObject:[NSNumber numberWithDouble:runKcal]];
    
    return resultArray;
}

/**
 * 计算一个人的步长
 * @param height cm
 * @param weight kg
 * @param stepFrequency 步频
 * @return 返回 m
 */
+ (double)calStepLength:(double)stepFrequency weight:(float)weight height:(float)height {
    return 0.004292 * height + 0.000641 * weight + 0.000334 * stepFrequency + 0.000182;
}

/**
 * 平均速度与梅脱的关系
 * @param speed 单位m/s 必须大于0
 * @param sex 0 女 1 男
 * @return
 */
+ (double)rmr:(double)speed sex:(int)sex {
    double rmrNumber = 0;
    BOOL isGirl = (sex == 0 ? YES : NO);
    if (0 < speed && speed <= 3) {
        rmrNumber = isGirl ? 2.5 : 3;
        
    } else if (3 < speed && speed <= 5) {
        rmrNumber = isGirl ? 4 : 5;
        
    } else if (5 < speed && speed <= 7) {
        rmrNumber = isGirl ? 5.5 : 7;
        
    } else if (7 < speed && speed <= 9) {
        rmrNumber = isGirl ? 7 : 9;
        
    } else if (9 < speed && speed <= 10) {
        rmrNumber = isGirl ? 9.5 : 10;
    }
    
    return rmrNumber;
}

/**
 * 根据体重和时间 ，算出在这段时间内静坐时消耗的卡路里
 * @param weight kg
 * @param duration 秒
 * @return 单位千卡
 */
+ (double)quietCalorie:(double)weight duration:(double)duration {
    return 3.5 / 1000 * 4.92 * weight * duration / 60;
}

/**
 * 运动时的卡路里消耗 不包含静坐
 * @param weight kg
 * @param duration 运动时间 秒
 * @param speed m/s
 * @param sex 0表示女 1表示男
 * @return 单位千卡
 */
+ (double)sportCalorie:(double)weight duration:(double)duration speed:(double)speed sex:(int)sex {
    return [self rmr:speed sex:sex] * 0.0167 * weight * duration / 60;
}

/**
 * 运动时的卡路里消耗
 * @param weight kg
 * @param duration 运动时间 秒
 * @param speed m/s
 * @param sex 0表示女 1表示男
 * @return 单位千卡
 */
+ (double)sportTotalCalorie:(double)weight duration:(double)duration speed:(double)speed sex:(int)sex {
    return [self quietCalorie:weight duration:duration] + [self sportCalorie:weight duration:duration speed:speed sex:sex];
}
@end

//
//  GBChartsLogic.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBChartsLogic.h"

@implementation GBChartsLogic

+ (UIColor *)chartColorWithIndex:(NSInteger)index {
    
    NSArray<UIColor *> *chartsColors = @[[UIColor colorWithHex:0x1091d2],
             [UIColor colorWithHex:0xdfa744],
             [UIColor colorWithHex:0x5e6cd9],
             [UIColor colorWithHex:0xb1637c],
             [UIColor colorWithHex:0x2fc35c],
             [UIColor colorWithHex:0x2fb9c3]];
    if (index<0 || index>=chartsColors.count) {
        return [UIColor clearColor];
    }
    
    return chartsColors[index];
}

+ (NSArray<ChartDataModel *> *)getRankList:(NSArray<TeamDataPlayerInfo *> *)list rankType:(GBGameRankType)rankType {
    
    if (list.count == 0) {  //显示默认值
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
        NSArray *defaultNames = @[@"T-Goal1号",@"T-Goal2号",@"T-Goal3号",@"T-Goal4号",@"T-Goal5号",@"T-Goal6号"];
        NSArray *defaultConuts = @[@(50), @(40), @(30), @(20), @(10), @(5)];
        NSArray *defaultSprints = @[@(50), @(40), @(30), @(20), @(10), @(5)];
        NSArray *defaultPowers = @[@(50), @(40), @(30), @(20), @(10), @(5)];
        NSArray *defaultEdurs = @[@(50), @(40), @(30), @(20), @(10), @(5)];
        NSArray *defaultAreas = @[@(30), @(25), @(20), @(15), @(10), @(5)];
        NSArray *defaultSpeeds = @[@(9.8), @(8), @(6), @(5), @(4), @(3)];
        NSArray *defaultDistances = @[@(8000), @(7000), @(6000), @(5000), @(4000), @(3000)];
        for (NSInteger i=0; i<6; i++) {
            ChartDataModel *model = [[ChartDataModel alloc] init];
            model.name = defaultNames[i];
            model.valueColor = [self chartColorWithIndex:i];
            switch (rankType) {
                case GameRankType_Count:
                    model.value = defaultConuts[i];
                    break;
                case GameRankType_Sprint:
                    model.value = defaultSprints[i];
                    break;
                case GameRankType_Erupt:
                    model.value = defaultPowers[i];
                    break;
                case GameRankType_Endur:
                    model.value = defaultEdurs[i];
                    break;
                case GameRankType_Area:
                    model.value = defaultAreas[i];
                    break;
                case GameRankType_MaxSpeed:
                    model.value = defaultSpeeds[i];
                    break;
                case GameRankType_Distance:
                    model.value = defaultDistances[i];
                    break;
                default:
                    break;
            }
            [result addObject:model];
        }
        
        return [result copy];
    }
    
    switch (rankType) {
        case GameRankType_Count:
            return [self sortWithCount:list];
            break;
        case GameRankType_Sprint:
            return [self sortWithSprint:list];
            break;
        case GameRankType_Erupt:
            return [self sortWithErupt:list];
            break;
        case GameRankType_Endur:
            return [self sortWithEndur:list];
            break;
        case GameRankType_Area:
            return [self sortWithArea:list];
            break;
        case GameRankType_MaxSpeed:
            return [self sortWithMaxSpeed:list];
            break;
        case GameRankType_Distance:
            return [self sortWithDistance:list];
            break;
        default:
            break;
    }
    return nil;
}

+ (NSArray<NSNumber *> *)dataWithPlayerStarInfo:(PlayerStarExtendInfo *)info {
    
    NSNumber *(^handleDataBlock)(CGFloat value) = ^NSNumber *(CGFloat value) {
        
        if (value<20) {
            return @(20);
        }else if (value>100) {
            return @(100);
        }
        return @(value);
    };
    
    NSMutableArray<NSNumber *> *values = [NSMutableArray arrayWithCapacity:1];
    [values addObject:handleDataBlock(info.cover_rate)];
    [values addObject:handleDataBlock(info.distance_count)];
    [values addObject:handleDataBlock(info.sprint_time)];
    [values addObject:handleDataBlock(info.power)];
    [values addObject:handleDataBlock(info.run_distance)];
    [values addObject:handleDataBlock(info.max_speed)];
    
    return [values copy];
}

#pragma mark - Private

+ (NSArray<ChartDataModel *> *)sortWithCount:(NSArray<TeamDataPlayerInfo *> *)list {
    
    NSArray *sortArray = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TeamDataPlayerInfo *info1 = obj1;
        TeamDataPlayerInfo *info2 = obj2;
        if (info1.match_count > info2.match_count) {
            return NSOrderedAscending;
        }else if (info1.match_count < info2.match_count){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sortArray.count];
    for(NSInteger index=0; index<sortArray.count; index++) {
        TeamDataPlayerInfo *info = sortArray[index];
        ChartDataModel *model = [[ChartDataModel alloc] init];
        model.name = info.abbreviateName;
        model.value = @(info.match_count);
        model.valueColor = [self chartColorWithIndex:index];
        if ([self playerIsMySelf:info]) {
            model.isMine = YES;
        }
        
        [result addObject:model];
    }
    return [result copy];
}

+ (NSArray<ChartDataModel *> *)sortWithSprint:(NSArray<TeamDataPlayerInfo *> *)list {
    
    NSArray *sortArray = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TeamDataPlayerInfo *info1 = obj1;
        TeamDataPlayerInfo *info2 = obj2;
        if (info1.sprint_time > info2.sprint_time) {
            return NSOrderedAscending;
        }else if (info1.sprint_time < info2.sprint_time){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sortArray.count];
    for(NSInteger index=0; index<sortArray.count; index++) {
        TeamDataPlayerInfo *info = sortArray[index];
        ChartDataModel *model = [[ChartDataModel alloc] init];
        model.name = info.abbreviateName;
        model.value = @(info.sprint_time);
        model.valueColor = [self chartColorWithIndex:index];
        if ([self playerIsMySelf:info]) {
            model.isMine = YES;
        }
        
        [result addObject:model];
    }
    return [result copy];
}

+ (NSArray<ChartDataModel *> *)sortWithErupt:(NSArray<TeamDataPlayerInfo *> *)list {
    
    NSArray *sortArray = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TeamDataPlayerInfo *info1 = obj1;
        TeamDataPlayerInfo *info2 = obj2;
        if (info1.power > info2.power) {
            return NSOrderedAscending;
        }else if (info1.power < info2.power){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sortArray.count];
    for(NSInteger index=0; index<sortArray.count; index++) {
        TeamDataPlayerInfo *info = sortArray[index];
        ChartDataModel *model = [[ChartDataModel alloc] init];
        model.name = info.abbreviateName;
        model.value = @(info.power);
        model.valueColor = [self chartColorWithIndex:index];
        if ([self playerIsMySelf:info]) {
            model.isMine = YES;
        }
        
        [result addObject:model];
    }
    return [result copy];
}

+ (NSArray<ChartDataModel *> *)sortWithEndur:(NSArray<TeamDataPlayerInfo *> *)list {
    
    NSArray *sortArray = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TeamDataPlayerInfo *info1 = obj1;
        TeamDataPlayerInfo *info2 = obj2;
        if (info1.run_distance > info2.run_distance) {
            return NSOrderedAscending;
        }else if (info1.run_distance < info2.run_distance){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sortArray.count];
    for(NSInteger index=0; index<sortArray.count; index++) {
        TeamDataPlayerInfo *info = sortArray[index];
        ChartDataModel *model = [[ChartDataModel alloc] init];
        model.name = info.abbreviateName;
        model.value = @(info.run_distance);
        model.valueColor = [self chartColorWithIndex:index];
        if ([self playerIsMySelf:info]) {
            model.isMine = YES;
        }
        
        [result addObject:model];
    }
    return [result copy];
}

+ (NSArray<ChartDataModel *> *)sortWithArea:(NSArray<TeamDataPlayerInfo *> *)list {
    
    NSArray *sortArray = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TeamDataPlayerInfo *info1 = obj1;
        TeamDataPlayerInfo *info2 = obj2;
        if (info1.cover_rate > info2.cover_rate) {
            return NSOrderedAscending;
        }else if (info1.cover_rate < info2.cover_rate){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sortArray.count];
    for(NSInteger index=0; index<sortArray.count; index++) {
        TeamDataPlayerInfo *info = sortArray[index];
        ChartDataModel *model = [[ChartDataModel alloc] init];
        model.name = info.abbreviateName;
        model.value = @(info.cover_rate);
        model.valueColor = [self chartColorWithIndex:index];
        if ([self playerIsMySelf:info]) {
            model.isMine = YES;
        }
        
        [result addObject:model];
    }
    return [result copy];
}

+ (NSArray<ChartDataModel *> *)sortWithMaxSpeed:(NSArray<TeamDataPlayerInfo *> *)list {
    
    NSArray *sortArray = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TeamDataPlayerInfo *info1 = obj1;
        TeamDataPlayerInfo *info2 = obj2;
        if (info1.max_speed> info2.max_speed) {
            return NSOrderedAscending;
        }else if (info1.max_speed < info2.max_speed){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sortArray.count];
    for(NSInteger index=0; index<sortArray.count; index++) {
        TeamDataPlayerInfo *info = sortArray[index];
        ChartDataModel *model = [[ChartDataModel alloc] init];
        model.name = info.abbreviateName;
        model.value = @(info.max_speed);
        model.valueColor = [self chartColorWithIndex:index];;
        if ([self playerIsMySelf:info]) {
            model.isMine = YES;
        }
        
        [result addObject:model];
    }
    return [result copy];
}

+ (NSArray<ChartDataModel *> *)sortWithDistance:(NSArray<TeamDataPlayerInfo *> *)list {
    
    NSArray *sortArray = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TeamDataPlayerInfo *info1 = obj1;
        TeamDataPlayerInfo *info2 = obj2;
        if (info1.distance_count > info2.distance_count) {
            return NSOrderedAscending;
        }else if (info1.distance_count < info2.distance_count){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sortArray.count];
    for(NSInteger index=0; index<sortArray.count; index++) {
        TeamDataPlayerInfo *info = sortArray[index];
        ChartDataModel *model = [[ChartDataModel alloc] init];
        model.name = info.abbreviateName;
        model.value = @(info.distance_count);
        model.valueColor = [self chartColorWithIndex:index];;
        if ([self playerIsMySelf:info]) {
            model.isMine = YES;
        }
        
        [result addObject:model];
    }
    return [result copy];

}

+ (BOOL)playerIsMySelf:(TeamDataPlayerInfo *)info {
    
    return [RawCacheManager sharedRawCacheManager].userInfo.userId==info.user_id;
}

@end

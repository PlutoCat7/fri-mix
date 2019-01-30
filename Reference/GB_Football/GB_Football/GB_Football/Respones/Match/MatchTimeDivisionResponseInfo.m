//
//  MatchTimeDivisionResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/1/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MatchTimeDivisionResponseInfo.h"

@implementation BarChartModel


@end

@implementation MatchTimeDivisionInfo


@end

@implementation MatchTimeDivisionResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"MatchTimeDivisionInfo"};
}

-(BarChartModel*)parse
{
    BarChartModel *model = [[BarChartModel alloc]init];
    // 距离
    NSMutableArray<NSString*> *topMoveTemp = [[NSMutableArray alloc]init];
    NSMutableArray<NSString*> *axiXMoveTemp = [[NSMutableArray alloc]init];
    NSMutableArray<NSNumber*> *progressMoveTemp = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < [self.data count]; i++)
    {
        MatchTimeDivisionInfo *item = (MatchTimeDivisionInfo*)self.data[i];
        [topMoveTemp addObject:item.move_distance <= 10 ?@" ":[self toKmString:item.move_distance]];
        [axiXMoveTemp addObject:[NSString stringWithFormat:@"%d",(int)15*(i+1)]];
    }
    model.topMove  = [topMoveTemp copy];
    model.axiXMove = [axiXMoveTemp copy];
    model.axiYMove = [self getAxiYMove:model.topMove];
    model.totalMove = [self getSum:model.topMove];
    CGFloat maxPrefMove = [self getMoveMaxPref:model.topMove];
    CGFloat scareY = [self scaleY:[model.axiYMove count]];
    for (int i = 0 ; i < [self.data count]; i++)
    {
        CGFloat progress = ([model.topMove[i] floatValue])*1.f/maxPrefMove*scareY;
        [progressMoveTemp addObject:@(progress)];
    }
    model.progressMove  = [progressMoveTemp copy];
    // 速度
    NSMutableArray<NSString*> *topSpeedTemp = [[NSMutableArray alloc]init];
    NSMutableArray<NSString*> *axiXSpeedTemp = [[NSMutableArray alloc]init];
    NSMutableArray<NSNumber*> *progressSpeedTemp = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < [self.data count]; i++){
        MatchTimeDivisionInfo *item = (MatchTimeDivisionInfo*)self.data[i];
        [topSpeedTemp addObject:[self toMSString:item.max_speed]];
        [axiXSpeedTemp addObject:[NSString stringWithFormat:@"%d",(int)15*(i+1)]];
    }
    model.topSpeed = [topSpeedTemp copy];
    model.axiXSpeed = [axiXSpeedTemp copy];
    model.axiYSpeed = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    model.maxSpeed = [self getMax:model.topSpeed];
    CGFloat maxPrefSpeed = 10.f;
    for (int i = 0 ; i < [self.data count]; i++){
        CGFloat progress = ([model.topSpeed[i] floatValue])*1.f/maxPrefSpeed*0.80;
        [progressSpeedTemp addObject:@(progress)];
    }
    model.progressSpeed  = [progressSpeedTemp copy];
    
    
    
    // 冗余处理
    NSInteger redundancyCount = 0;
    if ([self.data count] < 6)
    {
        redundancyCount  = 6 - [self.data count];
    }
    for (int i = 0; i < redundancyCount; i++) {
        [topMoveTemp addObject:@" "];
        [axiXMoveTemp addObject:[NSString stringWithFormat:@"%d",(int)(15*(i+1+[self.data count]))]];
        [progressMoveTemp addObject:@(0.0)];
        [topSpeedTemp addObject:@" "];
        [axiXSpeedTemp addObject:[NSString stringWithFormat:@"%d",(int)(15*(i+1+[self.data count]))]];
        [progressSpeedTemp addObject:@(0.0)];
    }
    model.topMove  = [topMoveTemp copy];
    model.axiXMove = [axiXMoveTemp copy];
    model.progressMove  = [progressMoveTemp copy];
    model.topSpeed = [topSpeedTemp copy];
    model.axiXSpeed = [axiXSpeedTemp copy];
    model.progressSpeed  = [progressSpeedTemp copy];
    return model;
}

// 向上0.5取整
-(NSArray<NSString*>*)getAxiYMove:(NSArray<NSString*>*)topmove
{
    float max = [[topmove valueForKeyPath:@"@max.floatValue"] floatValue];
    if (max > 0.0 && max < 0.5)
    {
        return @[@"0",@"0.5"];
    }
    else if (max >= 0.5 && max < 1.0)
    {
        return @[@"0",@"0.5",@"1"];
    }
    else if (max >= 1.0 && max < 1.5)
    {
        return @[@"0",@"0.5",@"1",@"1.5"];
    }
    else if (max >= 1.5 && max < 2.0)
    {
        return @[@"0",@"1",@"2"];
    }
    else
    {
        return @[@"0",@"1",@"2",@"3"];
    }
    return nil;
}

-(CGFloat)scaleY:(NSInteger)yCount
{
    switch (yCount)
     {
     case 2:return 0.5;break;
     case 3:return 0.70;break;
     case 4:return 0.75;break;
     default:break;
     }
     return 0.70;
}

-(NSString*)getMax:(NSArray<NSString*>*)speeds{
    float max = [[speeds valueForKeyPath:@"@max.floatValue"] floatValue];
    return [NSString stringWithFormat:@"%.2f",max];
}

-(NSString*)getSum:(NSArray<NSString*>*)moves{
    float sum = [[moves valueForKeyPath:@"@sum.floatValue"] floatValue];
    return [NSString stringWithFormat:@"%.2f",sum];
}

-(CGFloat)getMoveMaxPref:(NSArray<NSString*>*)topmove{
    float max = [[topmove valueForKeyPath:@"@max.floatValue"] floatValue];
    if (max < 0.5)
    {
        return 0.5;
    }
    else if (max >= 0.5 && max < 1.0)
    {
        return 1.0f;
    }
    else if (max >= 1.0 && max < 1.5)
    {
        return 1.5f;
    }
    else if (max >= 1.5 && max < 2.0)
    {
        return 2.0f;
    }
    else if (max >= 2.0)
    {
        return 3.f;
    }
    return 3.f;
}

- (NSString *)toKmString:(CGFloat)distance{
    return [NSString stringWithFormat:@"%.2f", distance/1000];
}

- (NSString *)toMSString:(CGFloat)time{
    return [NSString stringWithFormat:@"%.2f",time];
}

@end


//
//  TimeDivisionCellModel.h
//  GB_Football
//
//  Created by yahua on 2017/8/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeDivisionCellModel : NSObject

@property (nonatomic, copy) NSString *heatmapImageUrl;
@property (nonatomic, copy) NSString *sprintImageUrl;
@property (nonatomic, copy) NSString *coverAreaImageUrl;

@property (nonatomic, assign) NSInteger currentStyle;  //0热力图 1冲刺轨迹图 2覆盖面积
@property (nonatomic, assign) NSInteger coverAreaStyle; //0三区  1六区  2九区

//覆盖面积分布数据
@property (nonatomic, copy) NSString *sumRateString;    //总覆盖率
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *rateList;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *timeList;

- (NSArray<NSString *> *)currentRateInfo;
- (NSArray<NSString *> *)currentTimeInfo;

//翻转分布
- (void)swipeRateList;

@property (nonatomic, assign) BOOL isSwipe;

@end

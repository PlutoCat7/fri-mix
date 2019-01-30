//
//  GBHalfGameViewModel.m
//  GB_Football
//
//  Created by yahua on 2017/8/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBHalfGameViewModel.h"
#import "RecordLogic.h"

@interface GBHalfGameViewModel ()

@property (nonatomic, strong) GBFullGameModel *firstModel;

@property (nonatomic, strong) GBFullGameModel *secondModel;

@end

@implementation GBHalfGameViewModel

#pragma mark - Public

- (void)setMatchInfo:(MatchInfo *)matchInfo {
    
    _matchInfo = matchInfo;
    //上半场
    GBFullGameModel *model = [[GBFullGameModel alloc] init];
    model.heatmapImageUrl = matchInfo.heatmap_data.first_half_url;
    model.sprintImageUrl = matchInfo.heatmap_data.first_half_sprint_url;
    model.coverAreaImageUrl = matchInfo.heatmap_data.first_cover_area_url;
    model.sumRateString = [NSString stringWithFormat:@"%td%%", [RecordLogic totalRateWithCoverRate:matchInfo.heatmap_data.first_cover_area_rate]];
    model.rateList = [RecordLogic rateDetailWithCoverAreaInfo:matchInfo.heatmap_data.first_cover_area_info vertical:YES total:matchInfo.heatmap_data.first_cover_area_rate];
    
    NSInteger firstTotalTime = matchInfo.firstEndTime - matchInfo.firstStartTime;
    model.timeList = [RecordLogic rateDetailWithTimeRateInfo:matchInfo.heatmap_data.first_time_rate_info correct:matchInfo.heatmap_data.first_cover_area_info vertical:YES total:firstTotalTime];
    
    self.firstModel = model;
    
    //下半场
    model = [[GBFullGameModel alloc] init];
    model.heatmapImageUrl = matchInfo.heatmap_data.second_half_url;
    model.sprintImageUrl = matchInfo.heatmap_data.second_half_sprint_url;
    model.coverAreaImageUrl = matchInfo.heatmap_data.second_cover_area_url;
    model.sumRateString = [NSString stringWithFormat:@"%td%%", [RecordLogic totalRateWithCoverRate:matchInfo.heatmap_data.second_cover_area_rate]];
    model.rateList = [RecordLogic rateDetailWithCoverAreaInfo:matchInfo.heatmap_data.second_cover_area_info vertical:YES total:matchInfo.heatmap_data.second_cover_area_rate];
    
    NSInteger secondTotalTime = matchInfo.secondEndTime - matchInfo.secondStartTime;
    model.timeList = [RecordLogic rateDetailWithTimeRateInfo:matchInfo.heatmap_data.second_time_rate_info correct:matchInfo.heatmap_data.second_cover_area_info vertical:YES total:secondTotalTime];
    
    self.secondModel = model;
}

- (void)swipeCoverArea {
    
    [self.firstModel swipeRateList];
    [self.secondModel swipeRateList];
}

#pragma mark - Private


@end

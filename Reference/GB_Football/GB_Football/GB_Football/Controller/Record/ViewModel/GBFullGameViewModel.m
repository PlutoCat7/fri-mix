//
//  GBFullGameViewModel.m
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBFullGameViewModel.h"

#import "RecordLogic.h"

@interface GBFullGameViewModel ()

@property (nonatomic, strong) GBFullGameModel *model;

@end

@implementation GBFullGameViewModel

#pragma mark - Public

- (void)setMatchInfo:(MatchInfo *)matchInfo {
    
    _matchInfo = matchInfo;
    GBFullGameModel *model = [[GBFullGameModel alloc] init];
    model.heatmapImageUrl = matchInfo.heatmap_data.final_url;
    model.sprintImageUrl = matchInfo.heatmap_data.final_sprint_url;
    model.coverAreaImageUrl = matchInfo.heatmap_data.final_cover_area_url;
    model.sumRateString = [NSString stringWithFormat:@"%td%%", [RecordLogic totalRateWithCoverRate:matchInfo.heatmap_data.final_cover_area_rate]];
    model.rateList = [RecordLogic rateDetailWithCoverAreaInfo:matchInfo.heatmap_data.final_cover_area_info vertical:NO total:matchInfo.heatmap_data.final_cover_area_rate];
    
    NSInteger totalTime = matchInfo.firstEndTime - matchInfo.firstStartTime + matchInfo.secondEndTime - matchInfo.secondStartTime;
    model.timeList = [RecordLogic rateDetailWithTimeRateInfo:matchInfo.heatmap_data.final_time_rate_info correct:matchInfo.heatmap_data.final_cover_area_info vertical:NO total:totalTime];

    self.model = model;
}

- (void)swipeCoverArea {
    
    [self.model swipeRateList];
}


#pragma mark - Private

@end

//
//  TimeDivisionViewModel.m
//  GB_Football
//
//  Created by yahua on 2017/8/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TimeDivisionViewModel.h"
#import "RecordLogic.h"

@interface TimeDivisionViewModel ()

@end

@implementation TimeDivisionViewModel

#pragma mark - Public

- (UIColor *)colorWithInfo:(MatchSectonInfo *)compareInfo index:(NSInteger)index {
    
    if (self.sectionInfoList.count == 1) {
        return [UIColor whiteColor];
    }
    for (MatchSectonInfo *info in self.sectionInfoList) {
        if (info==compareInfo) {
            continue;
        }
        switch (index) {
            case 0:
                if (compareInfo.pc <= info.pc) {
                    return [UIColor whiteColor];
                }
                break;
            case 1:
                if (compareInfo.sprint_times <= info.sprint_times) {
                    return [UIColor whiteColor];
                }
                break;
            case 2:
                if (compareInfo.sprint_distance <= info.sprint_distance) {
                    return [UIColor whiteColor];
                }
                break;
            case 3:
                if (compareInfo.max_speed <= info.max_speed) {
                    return [UIColor whiteColor];
                }
                break;
            case 4:
                if (compareInfo.move_distance <= info.move_distance) {
                    return [UIColor whiteColor];
                }
                break;
                
            default:
                break;
        }
        
    }
    
    return [UIColor colorWithHex:0x01ff00];
}

#pragma mark - Private

#pragma mark - Setter and Getter

- (void)setSectionInfoList:(NSArray<MatchSectonInfo *> *)sectionInfoList {
    
    _sectionInfoList = sectionInfoList;
    NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:1];
    for (MatchSectonInfo *info in sectionInfoList) {
        TimeDivisionCellModel *model = [[TimeDivisionCellModel alloc] init];
        model.heatmapImageUrl = info.half_url;
        model.sprintImageUrl = info.sprint_url;
        model.coverAreaImageUrl = info.cover_area_url;
        model.rateList = [RecordLogic rateDetailWithCoverAreaInfo:info.cover_area_info vertical:NO total:info.cover_area_rate];
        
        NSInteger totalTime = info.end_time - info.start_time;
        model.timeList = [RecordLogic rateDetailWithTimeRateInfo:info.time_rate_info correct:info.cover_area_info vertical:NO total:totalTime];
        
        [tmpList addObject:model];
    }
    
    self.cellModelList = [tmpList copy];
}

- (void)setIsFlod:(BOOL)isFlod {
    
    _isFlod = isFlod;
}

@end

//
//  TimeDivisionViewModel.h
//  GB_Football
//
//  Created by yahua on 2017/8/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchInfo.h"
#import "TimeDivisionCellModel.h"

@interface TimeDivisionViewModel : NSObject

@property (nonatomic, strong) NSArray<MatchSectonInfo *> *sectionInfoList;
@property (nonatomic, strong) NSArray<TimeDivisionCellModel *> *cellModelList;

@property (nonatomic, assign) BOOL isFlod;

- (UIColor *)colorWithInfo:(MatchSectonInfo *)compareInfo index:(NSInteger)index;

@end

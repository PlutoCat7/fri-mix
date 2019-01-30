//
//  CoverAreaInfo.h
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"

@interface CoverAreaItemInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat blue_rate;
@property (nonatomic, assign) CGFloat green_rate;
@property (nonatomic, assign) CGFloat red_rate;
@property (nonatomic, assign) CGFloat yellow_rate;

@property (nonatomic, assign) CGFloat cover_rate;  //总覆盖率

@property (nonatomic, assign) NSInteger roundCoverRate;   //四舍五入的覆盖率

@end

@interface CoverAreaInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<CoverAreaItemInfo *> *ceil3; //3区
@property (nonatomic, strong) NSArray<CoverAreaItemInfo *> *ceil6; //3区
@property (nonatomic, strong) NSArray<CoverAreaItemInfo *> *ceil9; //3区


@end

//
//  RunResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"

@interface RunInfo : YAHActiveObject

@property (nonatomic, assign) CLLocationDegrees lat;
@property (nonatomic, assign) CLLocationDegrees lon;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGFloat speed;

@end

@interface RunSectionInfo : YAHActiveObject

@property (nonatomic, assign) CLLocationDegrees lat;
@property (nonatomic, assign) CLLocationDegrees lon;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) UIColor *startColor;

@property (nonatomic, assign) NSInteger speedInterval; //速度区间

@end

